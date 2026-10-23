import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://taskforge-backend-y3te.onrender.com';
  static const Duration timeoutDuration = Duration(seconds: 6);

  // In-memory fallback repository for reliable offline / cold-start operation
  static final List<Map<String, dynamic>> _mockProjects = [
    {
      'id': 1,
      'name': 'TaskForge Mobile App',
      'description': 'Flutter cross-platform task management client application',
      'status': 'ACTIVE',
      'tasks': 3,
      'completed': 1,
      'progress': 0.33,
    },
    {
      'id': 2,
      'name': 'Website Development',
      'description': 'Modern web dashboard with responsive landing and reporting',
      'status': 'PLANNING',
      'tasks': 2,
      'completed': 1,
      'progress': 0.50,
    },
    {
      'id': 3,
      'name': 'College Project',
      'description': 'Full stack collaborative platform with Spring Boot backend',
      'status': 'ACTIVE',
      'tasks': 2,
      'completed': 1,
      'progress': 0.50,
    },
  ];

  static final List<Map<String, dynamic>> _mockTasks = [
    {
      'id': 101,
      'title': 'Design Login Screen',
      'description': 'Create modern authentication UI with validation and responsive layout',
      'priority': 'HIGH',
      'status': 'DONE',
      'dueDate': '2026-10-20',
      'project': {'id': 1, 'name': 'TaskForge Mobile App'},
    },
    {
      'id': 102,
      'title': 'Create Dashboard UI',
      'description': 'Implement overview metrics, project progress bars, and recent activity',
      'priority': 'HIGH',
      'status': 'IN_PROGRESS',
      'dueDate': '2026-10-22',
      'project': {'id': 1, 'name': 'TaskForge Mobile App'},
    },
    {
      'id': 103,
      'title': 'Kanban Board Integration',
      'description': 'Add interactive drag-and-drop task workflow boards',
      'priority': 'MEDIUM',
      'status': 'TODO',
      'dueDate': '2026-10-25',
      'project': {'id': 1, 'name': 'TaskForge Mobile App'},
    },
    {
      'id': 104,
      'title': 'Database Schema Design',
      'description': 'Normalize entities, tables, and relational constraints for tasks and users',
      'priority': 'MEDIUM',
      'status': 'DONE',
      'dueDate': '2026-10-18',
      'project': {'id': 3, 'name': 'College Project'},
    },
    {
      'id': 105,
      'title': 'Spring Boot Security & JWT',
      'description': 'Configure security filters and token-based API authentication',
      'priority': 'HIGH',
      'status': 'TODO',
      'dueDate': '2026-10-28',
      'project': {'id': 3, 'name': 'College Project'},
    },
    {
      'id': 106,
      'title': 'API Documentation & Swagger',
      'description': 'Document RESTful endpoints and request payloads for frontend developers',
      'priority': 'LOW',
      'status': 'DONE',
      'dueDate': '2026-10-16',
      'project': {'id': 2, 'name': 'Website Development'},
    },
    {
      'id': 107,
      'title': 'SEO Optimization & Meta Tags',
      'description': 'Improve search ranking and open graph tags for the web application',
      'priority': 'LOW',
      'status': 'IN_PROGRESS',
      'dueDate': '2026-10-30',
      'project': {'id': 2, 'name': 'Website Development'},
    },
  ];

  // Helper to sync project task counts
  static void _recomputeProjectStats() {
    for (var project in _mockProjects) {
      final pId = project['id'];
      final matching = _mockTasks.where((t) => t['project']?['id'] == pId).toList();
      final done = matching.where((t) => t['status'] == 'DONE').length;
      project['tasks'] = matching.length;
      project['completed'] = done;
      project['progress'] = matching.isEmpty ? 0.0 : done / matching.length;
    }
  }

  // Get Projects
  static Future<List<dynamic>> getProjects() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/projects'))
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> remoteData = jsonDecode(response.body);
        // Sync to mock cache
        _mockProjects.clear();
        for (var p in remoteData) {
          _mockProjects.add(Map<String, dynamic>.from(p));
        }
        _recomputeProjectStats();
        return remoteData;
      }
    } catch (_) {
      // Backend offline or timed out; fallback to local store
    }
    _recomputeProjectStats();
    return List<dynamic>.from(_mockProjects);
  }

  // Create Project
  static Future<Map<String, dynamic>> createProject(
    Map<String, dynamic> project,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/projects'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(project),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final created = jsonDecode(response.body) as Map<String, dynamic>;
        _mockProjects.add(Map<String, dynamic>.from(created));
        _recomputeProjectStats();
        return created;
      }
    } catch (_) {
      // Fallback
    }

    final newProject = Map<String, dynamic>.from(project);
    newProject['id'] = project['id'] ?? DateTime.now().millisecondsSinceEpoch;
    newProject['tasks'] = 0;
    newProject['completed'] = 0;
    newProject['progress'] = 0.0;
    _mockProjects.add(newProject);
    return newProject;
  }

  // Get Tasks
  static Future<List<dynamic>> getTasks() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/tasks'))
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> remoteData = jsonDecode(response.body);
        _mockTasks.clear();
        for (var t in remoteData) {
          _mockTasks.add(Map<String, dynamic>.from(t));
        }
        _recomputeProjectStats();
        return remoteData;
      }
    } catch (_) {
      // Backend offline or timed out; fallback to local store
    }
    _recomputeProjectStats();
    return List<dynamic>.from(_mockTasks);
  }

  // Create Task
  static Future<Map<String, dynamic>> createTask(
    Map<String, dynamic> task,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/tasks'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(task),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final created = jsonDecode(response.body) as Map<String, dynamic>;
        _mockTasks.add(Map<String, dynamic>.from(created));
        _recomputeProjectStats();
        return created;
      }
    } catch (_) {
      // Fallback
    }

    final newTask = Map<String, dynamic>.from(task);
    newTask['id'] = DateTime.now().millisecondsSinceEpoch;
    
    // Enrich project name if needed
    if (newTask['project'] != null && newTask['project']['id'] != null) {
      final pId = newTask['project']['id'];
      final found = _mockProjects.where((p) => p['id'] == pId);
      if (found.isNotEmpty) {
        newTask['project']['name'] = found.first['name'];
      }
    }
    
    _mockTasks.add(newTask);
    _recomputeProjectStats();
    return newTask;
  }

  // Update Task
  static Future<Map<String, dynamic>> updateTask(
    int taskId,
    Map<String, dynamic> task,
  ) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/tasks/$taskId'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(task),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final updated = jsonDecode(response.body) as Map<String, dynamic>;
        final index = _mockTasks.indexWhere((t) => t['id'] == taskId);
        if (index != -1) {
          _mockTasks[index] = Map<String, dynamic>.from(updated);
        }
        _recomputeProjectStats();
        return updated;
      }
    } catch (_) {
      // Fallback
    }

    final index = _mockTasks.indexWhere((t) => t['id'] == taskId);
    if (index != -1) {
      final existing = _mockTasks[index];
      existing['title'] = task['title'] ?? existing['title'];
      existing['description'] = task['description'] ?? existing['description'];
      existing['status'] = task['status'] ?? existing['status'];
      existing['priority'] = task['priority'] ?? existing['priority'];
      if (task['project'] != null) {
        existing['project'] = task['project'];
      }
      _recomputeProjectStats();
      return existing;
    }

    final updated = Map<String, dynamic>.from(task);
    updated['id'] = taskId;
    _mockTasks.add(updated);
    _recomputeProjectStats();
    return updated;
  }

  // Delete Task
  static Future<void> deleteTask(int taskId) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/tasks/$taskId'))
          .timeout(timeoutDuration);

      if (response.statusCode == 200 || response.statusCode == 204) {
        _mockTasks.removeWhere((t) => t['id'] == taskId);
        _recomputeProjectStats();
        return;
      }
    } catch (_) {
      // Fallback
    }

    _mockTasks.removeWhere((t) => t['id'] == taskId);
    _recomputeProjectStats();
  }

  // Update Project
  static Future<Map<String, dynamic>> updateProject(
    int projectId,
    Map<String, dynamic> project,
  ) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/projects/$projectId'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(project),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final updated = jsonDecode(response.body) as Map<String, dynamic>;
        final index = _mockProjects.indexWhere((p) => p['id'] == projectId);
        if (index != -1) {
          _mockProjects[index] = Map<String, dynamic>.from(updated);
        }
        return updated;
      }
    } catch (_) {
      // Fallback
    }

    final index = _mockProjects.indexWhere((p) => p['id'] == projectId);
    if (index != -1) {
      _mockProjects[index]['name'] = project['name'] ?? _mockProjects[index]['name'];
      _mockProjects[index]['description'] = project['description'] ?? _mockProjects[index]['description'];
      _mockProjects[index]['status'] = project['status'] ?? _mockProjects[index]['status'];
      return _mockProjects[index];
    }

    final updated = Map<String, dynamic>.from(project);
    updated['id'] = projectId;
    _mockProjects.add(updated);
    return updated;
  }

  // Delete Project
  static Future<void> deleteProject(int projectId) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/projects/$projectId'))
          .timeout(timeoutDuration);

      if (response.statusCode == 200 || response.statusCode == 204) {
        _mockProjects.removeWhere((p) => p['id'] == projectId);
        _mockTasks.removeWhere((t) => t['project']?['id'] == projectId);
        return;
      }
    } catch (_) {
      // Fallback
    }

    _mockProjects.removeWhere((p) => p['id'] == projectId);
    _mockTasks.removeWhere((t) => t['project']?['id'] == projectId);
  }
}
