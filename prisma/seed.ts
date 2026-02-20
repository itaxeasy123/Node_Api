import { PrismaClient, UserType, UserGender } from "@prisma/client";
import bcrypt from "bcrypt";

const prisma = new PrismaClient();
async function main() {
  const password = "Admin@123"; // change after first login
  const hashedPassword = await bcrypt.hash(password, 10);

  /* ======================
     SUPER ADMIN
  ====================== */
  const superAdmin = await prisma.user.upsert({
    where: { email: "superadmin@itaxeasy.com" },
    update: {},
    create: {
      email: "superadmin@itaxeasy.com",
      password: hashedPassword,
      firstName: "Super",
      lastName: "Admin",
      gender: UserGender.male,
      userType: UserType.superadmin,
      verified: true,
    },
  });

  console.log("✅ SuperAdmin created:", superAdmin.email);

  /* ======================
     ADMIN
  ====================== */
 
  const admin = await prisma.user.upsert({
    where: { email: "admin@itaxeasy.com" },
    update: {},
    create: {
      email: "admin@itaxeasy.com",
      password: hashedPassword,
      firstName: "System",
      lastName: "Admin",
      gender: UserGender.male,
      userType: UserType.admin,
      verified: true,
      superadminId: superAdmin.id, // relation
    },
  });

  console.log("✅ Admin created:", admin.email);
}

main()
  .catch((e) => {
    console.error("❌ Seed failed:", e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });


