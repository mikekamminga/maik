import CoreData
import SwiftUI
import Combine

/// Repository for managing task persistence and data operations
/// Optimized for quick writes and efficient queries
class TaskRepository: ObservableObject {
    static let shared = TaskRepository()
    
    @Published var tasks: [TaskModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Core Data Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskDataModel")
        container.loadPersistentStores { [weak self] _, error in
            if let error = error {
                self?.handleError("Failed to load Core Data: \(error.localizedDescription)")
            }
        }
        
        // Configure for quick writes (ADHD-friendly)
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Initialization
    
    init() {
        fetchTasks()
    }
    
    // MARK: - CRUD Operations
    
    /// Add a new task (optimized for quick capture)
    func addTask(_ task: TaskModel, syncToWatch: Bool = true) {
        performBackgroundTask { [weak self] context in
            let taskEntity = TaskEntity(context: context)
            self?.configureTaskEntity(taskEntity, with: task)
            self?.saveContext(context)
            
            DispatchQueue.main.async {
                self?.fetchTasks()
                if syncToWatch {
                    // TODO: Implement watch sync in Issue #009
                }
            }
        }
    }
    
    /// Update an existing task
    func updateTask(_ task: TaskModel, syncToWatch: Bool = true) {
        performBackgroundTask { [weak self] context in
            let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
            
            do {
                let results = try context.fetch(request)
                if let taskEntity = results.first {
                    self?.configureTaskEntity(taskEntity, with: task)
                    self?.saveContext(context)
                    
                    DispatchQueue.main.async {
                        self?.fetchTasks()
                        if syncToWatch {
                            // TODO: Implement watch sync in Issue #009
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self?.handleError("Failed to update task: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// Delete a task
    func deleteTask(_ task: TaskModel, syncToWatch: Bool = true) {
        deleteTask(withId: task.id, syncToWatch: syncToWatch)
    }
    
    /// Delete a task by ID
    func deleteTask(withId id: UUID, syncToWatch: Bool = true) {
        performBackgroundTask { [weak self] context in
            let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try context.fetch(request)
                if let taskEntity = results.first {
                    context.delete(taskEntity)
                    self?.saveContext(context)
                    
                    DispatchQueue.main.async {
                        self?.fetchTasks()
                        if syncToWatch {
                            // TODO: Implement watch sync in Issue #009
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self?.handleError("Failed to delete task: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// Toggle task completion status
    func toggleTaskCompletion(_ task: TaskModel) {
        var updatedTask = task
        updatedTask.isCompleted.toggle()
        if updatedTask.isCompleted {
            updatedTask.completedAt = Date()
        } else {
            updatedTask.completedAt = nil
        }
        updateTask(updatedTask)
    }
    
    // MARK: - Query Operations
    
    /// Fetch all tasks from storage
    func fetchTasks() {
        isLoading = true
        
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TaskEntity.isCompleted, ascending: true),
            NSSortDescriptor(keyPath: \TaskEntity.priority, ascending: false),
            NSSortDescriptor(keyPath: \TaskEntity.dueDate, ascending: true),
            NSSortDescriptor(keyPath: \TaskEntity.createdAt, ascending: false)
        ]
        
        do {
            let taskEntities = try viewContext.fetch(request)
            tasks = taskEntities.compactMap { convertToTaskModel($0) }
            isLoading = false
            errorMessage = nil
        } catch {
            handleError("Failed to fetch tasks: \(error.localizedDescription)")
            isLoading = false
        }
    }
    
    /// Get tasks filtered by completion status
    func getTasks(completed: Bool) -> [TaskModel] {
        return tasks.filter { $0.isCompleted == completed }
    }
    
    /// Get tasks filtered by priority
    func getTasks(withPriority priority: TaskModel.Priority) -> [TaskModel] {
        return tasks.filter { $0.priority == priority }
    }
    
    /// Get overdue tasks
    func getOverdueTasks() -> [TaskModel] {
        return tasks.filter { $0.isOverdue }
    }
    
    /// Get tasks due today
    func getTasksDueToday() -> [TaskModel] {
        return tasks.filter { $0.isDueToday }
    }
    
    /// Search tasks by title
    func searchTasks(query: String) -> [TaskModel] {
        guard !query.isEmpty else { return tasks }
        return tasks.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }
    
    // MARK: - Utility Methods
    
    /// Refresh tasks from storage
    func refresh() {
        fetchTasks()
    }
    
    /// Get task count by category
    func getTaskCount() -> (total: Int, completed: Int, pending: Int, overdue: Int) {
        let total = tasks.count
        let completed = tasks.filter(\.isCompleted).count
        let pending = tasks.filter { !$0.isCompleted }.count
        let overdue = tasks.filter(\.isOverdue).count
        
        return (total: total, completed: completed, pending: pending, overdue: overdue)
    }
    
    // MARK: - Private Methods
    
    private func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            block(context)
        }
    }
    
    private func saveContext(_ context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.handleError("Failed to save context: \(error.localizedDescription)")
            }
        }
    }
    
    private func configureTaskEntity(_ entity: TaskEntity, with task: TaskModel) {
        entity.id = task.id
        entity.title = task.title
        entity.dueDate = task.dueDate
        entity.priority = Int16(task.priority.rawValue.hashValue)
        entity.tags = task.tags.joined(separator: ",")
        entity.isCompleted = task.isCompleted
        entity.createdAt = task.createdAt
        entity.completedAt = task.completedAt
        entity.notes = task.notes
    }
    
    private func convertToTaskModel(_ entity: TaskEntity) -> TaskModel? {
        guard let id = entity.id,
              let title = entity.title,
              let createdAt = entity.createdAt else {
            return nil
        }
        
        let priority = TaskModel.Priority.allCases.first { 
            $0.rawValue.hashValue == Int(entity.priority) 
        } ?? .medium
        
        let tags = entity.tags?.split(separator: ",").map(String.init) ?? []
        
        return TaskModel(
            id: id,
            title: title,
            dueDate: entity.dueDate,
            priority: priority,
            tags: tags,
            isCompleted: entity.isCompleted,
            createdAt: createdAt,
            completedAt: entity.completedAt,
            notes: entity.notes
        )
    }
    
    private func handleError(_ message: String) {
        print("TaskRepository Error: \(message)")
        errorMessage = message
    }
}

// MARK: - TaskModel Extension

extension TaskModel {
    init(id: UUID = UUID(), title: String, dueDate: Date? = nil, priority: Priority = .medium, tags: [String] = [], isCompleted: Bool = false, createdAt: Date = Date(), completedAt: Date? = nil, notes: String? = nil) {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.priority = priority
        self.tags = tags
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.completedAt = completedAt
        self.notes = notes
    }
} 