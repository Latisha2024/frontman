const express = require('express');
const router = express.Router();
const authorizeRoles = require('../../middlewares/roleCheck');
const authenticate = require('../../middlewares/auth');
const cameraController = require('../../controllers/cameraController');
const multer = require('multer');

// Configure multer for file uploads
const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB limit
  },
  fileFilter: (req, file, cb) => {
    if (file.mimetype.startsWith('image/')) {
      cb(null, true);
    } else {
      cb(new Error('Only image files are allowed'), false);
    }
  },
});

/**
 * @swagger
 * tags:
 *   name: Field Executive Camera
 *   description: Camera functionality for Field Executives
 */

router.use(authenticate);
router.use(authorizeRoles('FieldExecutive'));

/**
 * @swagger
 * /fieldExecutive/camera/upload:
 *   post:
 *     summary: Upload an image with GPS location
 *     tags: [Field Executive Camera]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             required:
 *               - latitude
 *               - longitude
 *               - image
 *             properties:
 *               latitude:
 *                 type: number
 *                 description: Latitude coordinate
 *               longitude:
 *                 type: number
 *                 description: Longitude coordinate
 *               description:
 *                 type: string
 *                 description: Optional description of the image
 *               image:
 *                 type: string
 *                 format: binary
 *                 description: Image file
 *     responses:
 *       201:
 *         description: Image uploaded successfully
 *       400:
 *         description: Invalid input data
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Server error
 */
router.post('/upload', upload.single('image'), cameraController.uploadImage);

/**
 * @swagger
 * /fieldExecutive/camera/images:
 *   get:
 *     summary: Get all images uploaded by the field executive
 *     tags: [Field Executive Camera]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of images
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Server error
 */
router.get('/images', cameraController.getMyImages);

module.exports = router;