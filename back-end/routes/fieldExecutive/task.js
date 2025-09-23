const express = require('express');
const router = express.Router();

const authenticate = require('../../middlewares/auth');
const authorizeRoles = require('../../middlewares/roleCheck');
const taskController = require('../../controllers/taskController');

/**
 * @swagger
 * tags:
 *   name: Tasks
 *   description: Field Executive Task Management
 */

router.use(authenticate);
router.use(authorizeRoles('FieldExecutive'));

/**
 * @swagger
 * /field-executive/tasks:
 *   get:
 *     summary: Get all tasks for the logged-in Field Executive
 *     tags: [Tasks]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of tasks
 *       403:
 *         description: Not authorized as Field Executive
 *       500:
 *         description: Server error
 */
router.get('/', taskController.getTasks);

/**
 * @swagger
 * /field-executive/tasks:
 *   post:
 *     summary: Create a new task
 *     tags: [Tasks]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               title:
 *                 type: string
 *                 example: "Visit Client X"
 *               description:
 *                 type: string
 *                 example: "Meet with Client X to discuss new products"
 *               status:
 *                 type: string
 *                 enum: [Pending, InProgress, Completed]
 *                 example: "Pending"
 *               dueDate:
 *                 type: string
 *                 format: date-time
 *                 example: "2023-12-31T12:00:00Z"
 *     responses:
 *       201:
 *         description: Task created
 *       403:
 *         description: Not authorized as Field Executive
 *       500:
 *         description: Server error
 */
router.post('/', taskController.createTask);

/**
 * @swagger
 * /field-executive/tasks/{id}:
 *   put:
 *     summary: Update a task
 *     tags: [Tasks]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               title:
 *                 type: string
 *               description:
 *                 type: string
 *               dueDate:
 *                 type: string
 *                 format: date-time
 *     responses:
 *       200:
 *         description: Task updated
 *       403:
 *         description: Not authorized as Field Executive
 *       404:
 *         description: Task not found
 *       500:
 *         description: Server error
 */
router.put('/:id', taskController.updateTask);

/**
 * @swagger
 * /field-executive/tasks/{id}/status:
 *   patch:
 *     summary: Update task status
 *     tags: [Tasks]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               status:
 *                 type: string
 *                 enum: [Pending, InProgress, Completed]
 *     responses:
 *       200:
 *         description: Task status updated
 *       403:
 *         description: Not authorized as Field Executive
 *       404:
 *         description: Task not found
 *       500:
 *         description: Server error
 */
router.patch('/:id/status', taskController.updateTaskStatus);

/**
 * @swagger
 * /field-executive/tasks/{id}:
 *   delete:
 *     summary: Delete a task
 *     tags: [Tasks]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Task deleted
 *       403:
 *         description: Not authorized as Field Executive
 *       404:
 *         description: Task not found
 *       500:
 *         description: Server error
 */
router.delete('/:id', taskController.deleteTask);

module.exports = router;