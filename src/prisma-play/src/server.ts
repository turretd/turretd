import express from 'express'
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

const app = express()

app.get('/', async (req: any, res: { send: (arg0: string) => void }) => {
  return prisma.user.findMany()
})

export default app