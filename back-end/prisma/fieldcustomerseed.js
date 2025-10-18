const bcrypt = require('bcrypt');
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  // 1) Create Dummy FieldExecutive user + role
  const passwordHash = await bcrypt.hash('password123', 10);

  const fieldExecUser = await prisma.user.upsert({
    where: { email: 'fieldexec.dummy@example.com' },
    update: {},
    create: {
      name: 'Dummy FieldExecutive',
      email: 'fieldexec.dummy@example.com',
      phone: '9000000000',
      password: passwordHash,
      role: 'FieldExecutive',
    },
  });

  const fieldExecRole = await prisma.fieldExecutive.upsert({
    where: { userId: fieldExecUser.id },
    update: {},
    create: {
      userId: fieldExecUser.id,
    },
  });

  console.log('✔ Dummy FieldExecutive');
  console.log('  - userId:', fieldExecUser.id);
  console.log('  - fieldExecutiveId:', fieldExecRole.id);
  console.log('  - email: fieldexec.dummy@example.com');
  console.log('  - password: password123');

  // 2) Create several Customers assigned to this FieldExecutive
  const customersToEnsure = [
    { name: 'Acme Retail', phone: '8888880001', location: 'Central City' },
    { name: 'Bright Supplies', phone: '8888880002', location: 'North Zone' },
    { name: 'Coastal Traders', phone: '8888880003', location: 'Harbor Area' },
  ];

  const createdCustomers = [];
  for (const c of customersToEnsure) {
    let existing = await prisma.customer.findFirst({
      where: { name: c.name, phone: c.phone },
    });
    if (!existing) {
      existing = await prisma.customer.create({
        data: {
          name: c.name,
          phone: c.phone,
          location: c.location,
          assignedTo: fieldExecRole.id,
        },
      });
      console.log('✔ Customer created:', existing.name, 'id:', existing.id);
    } else {
      // Ensure assignment
      if (existing.assignedTo !== fieldExecRole.id) {
        existing = await prisma.customer.update({
          where: { id: existing.id },
          data: { assignedTo: fieldExecRole.id },
        });
        console.log('↺ Customer reassigned to dummy FE:', existing.name, 'id:', existing.id);
      } else {
        console.log('• Customer already exists:', existing.name, 'id:', existing.id);
      }
    }
    createdCustomers.push(existing);
  }

  // 3) Print a short summary with IDs for quick testing
  console.log('\nTest with these IDs in the app:');
  console.log('  FieldExecutiveId:', fieldExecRole.id);
  createdCustomers.forEach((cust, idx) => {
    console.log(`  Customer ${idx + 1}:`, cust.name, '-> id:', cust.id);
  });

  // 4) Optional: create a follow-up for the first customer to validate relations
  if (createdCustomers.length > 0) {
    const followUp = await prisma.customerFollowUp.create({
      data: {
        executiveId: fieldExecRole.id,
        customerName: createdCustomers[0].name,
        contactDetails: createdCustomers[0].phone,
        feedback: 'Seed: initial contact',
        status: 'Pending',
        nextFollowUpDate: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
      },
    });
    console.log('✔ Sample follow-up created:', followUp.id);
  }
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
