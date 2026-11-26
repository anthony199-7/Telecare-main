import express from 'express'
import cors from 'cors'
import 'dotenv/config'
import connectDB from './config/mongodb.js'
import connectCloudinary from './config/cloudinary.js'
import adminRouter from './routes/adminRoute.js'
import doctorRouter from './routes/doctorRouter.js'
import userRouter from './routes/userRoute.js'

// App Config [1]
const app = express()
const port = process.env.PORT || 8080
connectDB()
connectCloudinary()

// Middlewares [4]
app.use(express.json())
app.use(cors())

// API Endpoints [5-7]
app.use('/api/admin', adminRouter)
app.use('/api/doctor', doctorRouter)
app.use('/api/user', userRouter)

app.get('/', (req, res) => {
    res.send('API Working')
})

app.listen(port, '0.0.0.0', () => console.log('Server started', port));
