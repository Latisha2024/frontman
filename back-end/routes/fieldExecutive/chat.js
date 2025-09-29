const express = require('express');
const router = express.Router();
const authorizeRoles = require('../../middlewares/roleCheck');
const authenticate = require('../../middlewares/auth');
const chatController = require('../../controllers/chatController');

/**
 * @swagger
 * tags:
 *   name: Field Executive Chat
 *   description: Chat functionality for Field Executives
 */

router.use(authenticate);
router.use(authorizeRoles('FieldExecutive'));

/**
 * @swagger
 * /fieldExecutive/chat/messages:
 *   get:
 *     summary: Get all chat messages for the field executive
 *     tags: [Field Executive Chat]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of messages
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Server error
 */
router.get('/messages', chatController.getMessages);

/**
 * @swagger
 * /fieldExecutive/chat/send:
 *   post:
 *     summary: Send a new chat message
 *     tags: [Field Executive Chat]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - content
 *             properties:
 *               content:
 *                 type: string
 *                 description: Message content
 *               recipientId:
 *                 type: string
 *                 description: ID of the recipient (optional for broadcast)
 *     responses:
 *       201:
 *         description: Message sent successfully
 *       400:
 *         description: Invalid input data
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Server error
 */
router.post('/send', chatController.sendMessage);

module.exports = router;