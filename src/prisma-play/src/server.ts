import express from 'express'

const app = express()
const port = 3000

app.get('/', (req: any, res: { send: (arg0: string) => void }) => {
  res.send('Hello World!')
})

export default app