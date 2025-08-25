const express = require('express');
const router = express.Router();
const authorizeRoles = require('../../middlewares/roleCheck');
const authenticate = require('../../middlewares/auth');
const incentiveController = require('../../controllers/incentiveController');

/**
 * @swagger
 * tags:
 *   name: External Seller Incentives
 *   description: Incentive tracking for External Sellers
 */

router.use(authenticate);
router.use(authorizeRoles('ExternalSeller'));

/**
 * @swagger
 * /user/incentives:
 *   get:
 *     summary: Get logged-in External Seller's incentives
 *     tags: [External Seller Incentives]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of incentives
 *       401:
 *         description: Unauthorized or invalid token
 *       500:
 *         description: Server error while fetching incentives
 */
router.get('/', incentiveController.getMyIncentives);

module.exports = router;
