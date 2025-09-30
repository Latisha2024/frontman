const express = require('express');
const router = express.Router();
const salesExecutiveController = require('../../controllers/salesExecutiveController');
const auth = require('../../middlewares/auth');
const authorizeRoles = require('../../middlewares/roleCheck');

/**
 * @swagger
 * components:
 *   schemas:
 *     Location:
 *       type: object
 *       required:
 *         - latitude
 *         - longitude
 *       properties:
 *         latitude:
 *           type: number
 *           description: Latitude coordinate
 *         longitude:
 *           type: number
 *           description: Longitude coordinate
 */

/**
 * @swagger
 * tags:
 *   name: Field Executive Location
 *   description: GPS location tracking for Field Executives
 */

router.use(auth);
router.use(authorizeRoles('FieldExecutive'));

/**
 * @swagger
 * /fieldExecutive/location:
 *   post:
 *     summary: Submit GPS location
 *     tags: [Field Executive Location]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - latitude
 *               - longitude
 *             properties:
 *               latitude:
 *                 type: number
 *                 example: 28.6139
 *               longitude:
 *                 type: number
 *                 example: 77.2090
 *     responses:
 *       201:
 *         description: Location recorded successfully
 *       400:
 *         description: Invalid coordinates
 *       500:
 *         description: Server error
 */
router.post('/', salesExecutiveController.submitLocation);

/**
 * @swagger
 * /fieldExecutive/location:
 *   get:
 *     summary: Get my location history
 *     tags: [Field Executive Location]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Location history retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Location'
 *       500:
 *         description: Server error
 */
router.get('/', salesExecutiveController.getMyLocationHistory);

module.exports = router;
