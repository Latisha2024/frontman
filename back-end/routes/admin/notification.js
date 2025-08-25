const express = require('express');
const router = express.Router();

const authenticate = require('../../middlewares/auth');
const authorizeRoles = require('../../middlewares/roleCheck');
const notificationController = require('../../controllers/notificationController');

/**
 * @swagger
 * tags:
 *   name: Admin Notifications
 *   description: Admin notification management
 */

router.use(authenticate);
router.use(authorizeRoles('Admin'));

/**
 * @swagger
 * /admin/notifications:
 *   get:
 *     summary: Get all notifications
 *     tags: [Admin Notifications]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of notifications
 *       500:
 *         description: Server error
 */
router.get('/', notificationController.getNotifications);

/**
 * @swagger
 * /admin/notifications:
 *   post:
 *     summary: Create a new notification
 *     tags: [Admin Notifications]
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
 *               message:
 *                 type: string
 *               recipients:
 *                 type: array
 *                 items:
 *                   type: string
 *             required:
 *               - title
 *               - message
 *     responses:
 *       201:
 *         description: Notification created
 *       400:
 *         description: Bad request
 *       500:
 *         description: Server error
 */
router.post('/', notificationController.createNotification);

/**
 * @swagger
 * /admin/notifications/{id}/read:
 *   put:
 *     summary: Mark a specific notification as read
 *     tags: [Admin Notifications]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Notification ID
 *     responses:
 *       200:
 *         description: Notification marked as read
 *       404:
 *         description: Notification not found
 *       500:
 *         description: Server error
 */
router.put('/:id/read', notificationController.markAsRead);

/**
 * @swagger
 * /admin/notifications/read-all:
 *   put:
 *     summary: Mark all notifications as read
 *     tags: [Admin Notifications]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: All notifications marked as read
 *       500:
 *         description: Server error
 */
router.put('/read-all', notificationController.markAllAsRead);

module.exports = router;
