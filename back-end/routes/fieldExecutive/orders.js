const express = require('express');
const router = express.Router();
const salesExecutiveController = require('../../controllers/salesExecutiveController');
const auth = require('../../middlewares/auth');
const authorizeRoles = require('../../middlewares/roleCheck');

/**
 * @swagger
 * components:
 *   schemas:
 *     Product:
 *       type: object
 *       properties:
 *         id:
 *           type: string
 *         name:
 *           type: string
 *         price:
 *           type: number
 *         stockQuantity:
 *           type: integer
 *         warrantyPeriodInMonths:
 *           type: integer
 *         category:
 *           type: object
 *           properties:
 *             id:
 *               type: string
 *             name:
 *               type: string
 *     
 *     CartItem:
 *       type: object
 *       properties:
 *         id:
 *           type: string
 *         productId:
 *           type: string
 *         quantity:
 *           type: integer
 *         product:
 *           $ref: '#/components/schemas/Product'
 *     
 *     Cart:
 *       type: object
 *       properties:
 *         id:
 *           type: string
 *         userId:
 *           type: string
 *         status:
 *           type: string
 *         items:
 *           type: array
 *           items:
 *             $ref: '#/components/schemas/CartItem'
 *         createdAt:
 *           type: string
 *           format: date-time
 *         updatedAt:
 *           type: string
 *           format: date-time
 *     
 *     Order:
 *       type: object
 *       properties:
 *         id:
 *           type: string
 *         userId:
 *           type: string
 *         status:
 *           type: string
 *           enum: [Pending, Completed, Cancelled]
 *         orderDate:
 *           type: string
 *           format: date-time
 *         totalAmount:
 *           type: number
 *         items:
 *           type: array
 *           items:
 *             type: object
 *             properties:
 *               productName:
 *                 type: string
 *               quantity:
 *                 type: integer
 *               unitPrice:
 *                 type: number
 */

/**
 * @swagger
 * tags:
 *   name: Field Executive Orders
 *   description: Order management for Field Executives
 */

router.use(auth);
router.use(authorizeRoles('FieldExecutive'));

/**
 * @swagger
 * /fieldExecutive/orders/products:
 *   get:
 *     summary: Get all products
 *     tags: [Field Executive Orders]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: categoryId
 *         schema:
 *           type: string
 *         description: Filter products by category
 *       - in: query
 *         name: search
 *         schema:
 *           type: string
 *         description: Search products by name
 *     responses:
 *       200:
 *         description: Products retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Product'
 *       500:
 *         description: Server error
 */
router.get('/products', salesExecutiveController.getProducts);

/**
 * @swagger
 * /fieldExecutive/orders/products/{id}:
 *   get:
 *     summary: Get product details by ID
 *     tags: [Field Executive Orders]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Product ID
 *     responses:
 *       200:
 *         description: Product details retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Product'
 *       404:
 *         description: Product not found
 *       500:
 *         description: Server error
 */
router.get('/products/:id', salesExecutiveController.getProductById);

/**
 * @swagger
 * /fieldExecutive/orders/products/{id}/stock:
 *   get:
 *     summary: Check product stock
 *     tags: [Field Executive Orders]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Product ID
 *     responses:
 *       200:
 *         description: Stock information retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 productId:
 *                   type: string
 *                 productName:
 *                   type: string
 *                 stockQuantity:
 *                   type: integer
 *                 inStock:
 *                   type: boolean
 *       404:
 *         description: Product not found
 *       500:
 *         description: Server error
 */
router.get('/products/:id/stock', salesExecutiveController.checkStock);

/**
 * @swagger
 * /fieldExecutive/orders/cart:
 *   get:
 *     summary: Get my cart
 *     tags: [Field Executive Orders]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Cart retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 cart:
 *                   $ref: '#/components/schemas/Cart'
 *                 total:
 *                   type: number
 *       500:
 *         description: Server error
 */
router.get('/cart', salesExecutiveController.getCart);

/**
 * @swagger
 * /fieldExecutive/orders/cart:
 *   post:
 *     summary: Add item to cart
 *     tags: [Field Executive Orders]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - productId
 *               - quantity
 *             properties:
 *               productId:
 *                 type: string
 *               quantity:
 *                 type: integer
 *                 minimum: 1
 *     responses:
 *       200:
 *         description: Item added to cart successfully
 *       400:
 *         description: Invalid product ID or quantity
 *       404:
 *         description: Product not found
 *       500:
 *         description: Server error
 */
router.post('/cart', salesExecutiveController.addToCart);

/**
 * @swagger
 * /fieldExecutive/orders/cart/{itemId}:
 *   delete:
 *     summary: Remove item from cart
 *     tags: [Field Executive Orders]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: itemId
 *         required: true
 *         schema:
 *           type: string
 *         description: Cart item ID
 *     responses:
 *       200:
 *         description: Item removed from cart successfully
 *       404:
 *         description: Item not found in cart
 *       500:
 *         description: Server error
 */
router.delete('/cart/:itemId', salesExecutiveController.removeFromCart);

/**
 * @swagger
 * /fieldExecutive/orders/cart:
 *   delete:
 *     summary: Clear cart
 *     tags: [Field Executive Orders]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Cart cleared successfully
 *       500:
 *         description: Server error
 */
router.delete('/cart', salesExecutiveController.clearCart);

/**
 * @swagger
 * /fieldExecutive/orders:
 *   post:
 *     summary: Place order
 *     tags: [Field Executive Orders]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - items
 *             properties:
 *               items:
 *                 type: array
 *                 items:
 *                   type: object
 *                   required:
 *                     - productId
 *                     - quantity
 *                   properties:
 *                     productId:
 *                       type: string
 *                     quantity:
 *                       type: integer
 *                       minimum: 1
 *               promoCode:
 *                 type: string
 *                 description: Optional promo code
 *     responses:
 *       201:
 *         description: Order placed successfully
 *       400:
 *         description: Invalid order data
 *       500:
 *         description: Server error
 */
router.post('/', salesExecutiveController.placeOrder);

/**
 * @swagger
 * /fieldExecutive/orders:
 *   get:
 *     summary: Get my orders
 *     tags: [Field Executive Orders]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Orders retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Order'
 *       500:
 *         description: Server error
 */
router.get('/', salesExecutiveController.getMyOrders);

module.exports = router;
