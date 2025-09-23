const prisma = require('../prisma/prisma');

const taskController = {
  // GET /field-executive/tasks
  getTasks: async (req, res) => {
    try {
      const executiveId = req.user.id;

      const executive = await prisma.fieldExecutive.findUnique({
        where: { userId: executiveId },
      });

      if (!executive) {
        return res.status(403).json({ message: 'Not a Field Executive' });
      }

      const tasks = await prisma.task.findMany({
        where: { executiveId: executive.id },
        orderBy: { dueDate: 'asc' },
      });

      res.json(tasks);
    } catch (err) {
      console.error('Error in getTasks:', err);
      res.status(500).json({ message: 'Failed to fetch tasks' });
    }
  },

  // POST /field-executive/tasks
  createTask: async (req, res) => {
    try {
      const { title, description, status, dueDate } = req.body;
      const executiveId = req.user.id;

      const executive = await prisma.fieldExecutive.findUnique({
        where: { userId: executiveId },
      });

      if (!executive) {
        return res.status(403).json({ message: 'Not a Field Executive' });
      }

      const task = await prisma.task.create({
        data: {
          title,
          description,
          status: status || 'Pending',
          dueDate: dueDate ? new Date(dueDate) : null,
          executiveId: executive.id,
        },
      });

      res.status(201).json({ message: 'Task created', task });
    } catch (err) {
      console.error('Error in createTask:', err);
      res.status(500).json({ message: 'Failed to create task' });
    }
  },

  // PUT /field-executive/tasks/:id
  updateTask: async (req, res) => {
    try {
      const { id } = req.params;
      const { title, description, dueDate } = req.body;
      const executiveId = req.user.id;

      const executive = await prisma.fieldExecutive.findUnique({
        where: { userId: executiveId },
      });

      if (!executive) {
        return res.status(403).json({ message: 'Not a Field Executive' });
      }

      // Ensure the task belongs to this executive
      const existingTask = await prisma.task.findFirst({
        where: {
          id,
          executiveId: executive.id,
        },
      });

      if (!existingTask) {
        return res.status(404).json({ message: 'Task not found' });
      }

      const updated = await prisma.task.update({
        where: { id },
        data: {
          title,
          description,
          dueDate: dueDate ? new Date(dueDate) : null,
        },
      });

      res.json({ message: 'Task updated', task: updated });
    } catch (err) {
      console.error('Error in updateTask:', err);
      res.status(500).json({ message: 'Failed to update task' });
    }
  },

  // PATCH /field-executive/tasks/:id/status
  updateTaskStatus: async (req, res) => {
    try {
      const { id } = req.params;
      const { status } = req.body;
      const executiveId = req.user.id;

      const executive = await prisma.fieldExecutive.findUnique({
        where: { userId: executiveId },
      });

      if (!executive) {
        return res.status(403).json({ message: 'Not a Field Executive' });
      }

      // Ensure the task belongs to this executive
      const existingTask = await prisma.task.findFirst({
        where: {
          id,
          executiveId: executive.id,
        },
      });

      if (!existingTask) {
        return res.status(404).json({ message: 'Task not found' });
      }

      const updated = await prisma.task.update({
        where: { id },
        data: { status },
      });

      res.json({ message: 'Task status updated', task: updated });
    } catch (err) {
      console.error('Error in updateTaskStatus:', err);
      res.status(500).json({ message: 'Failed to update task status' });
    }
  },

  // DELETE /field-executive/tasks/:id
  deleteTask: async (req, res) => {
    try {
      const { id } = req.params;
      const executiveId = req.user.id;

      const executive = await prisma.fieldExecutive.findUnique({
        where: { userId: executiveId },
      });

      if (!executive) {
        return res.status(403).json({ message: 'Not a Field Executive' });
      }

      // Ensure the task belongs to this executive
      const existingTask = await prisma.task.findFirst({
        where: {
          id,
          executiveId: executive.id,
        },
      });

      if (!existingTask) {
        return res.status(404).json({ message: 'Task not found' });
      }

      await prisma.task.delete({
        where: { id },
      });

      res.json({ message: 'Task deleted' });
    } catch (err) {
      console.error('Error in deleteTask:', err);
      res.status(500).json({ message: 'Failed to delete task' });
    }
  },
};

module.exports = taskController;