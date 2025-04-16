# Good Night Api

This app allows users to track when they go to bed and when they wake up. Users can follow others to see their sleep schedules and can also be followed.

See diagram [here](https://drive.google.com/file/d/1P-VDda2fN743ubPgNj_sBKheqnjpLOCA/view?usp=sharing)

## Database

### **Users**
| Column      | Type     | Description           |
|-------------|----------|-----------------------|
| id          | integer  | Primary key           |
| name        | string   | Required              |
| created_at  | datetime | Record creation time  |
| updated_at  | datetime | Last update time      |

---

### **SleepRecords**
Tracks when a user clocks in and out for sleep.

| Column         | Type     | Description                              |
|----------------|----------|------------------------------------------|
| id             | integer  | Primary key                              |
| user_id        | integer  | Foreign key to `users`                   |
| clocked_in_at  | datetime | Time user went to sleep (Required)       |
| clocked_out_at | datetime | Time user woke up (Nullable until clocked out) |
| created_at     | datetime | Record creation time                     |
| updated_at     | datetime | Last update time                         |

**Indexes**:
- `index_sleep_records_on_user_id`

**Foreign Keys**:
- `user_id` -> `users(id)`

---

### **Followings**
Represents a follower-followed relationship between users.

| Column       | Type     | Description                    |
|--------------|----------|--------------------------------|
| id           | integer  | Primary key                    |
| follower_id  | integer  | User who follows               |
| followed_id  | integer  | User being followed            |
| created_at   | datetime | Record creation time           |
| updated_at   | datetime | Last update time               |

**Indexes**:
- `index_followings_on_followed_id` 
- `index_followings_on_follower_id` 
- `index_followings_on_followed_id_and_follower_id (unique)` 

**Foreign Keys**:
- `follower_id` -> `users(id)`
- `followed_id` -> `users(id)`

## API Endpoints

### Authentication

| Method | Path     | Description                    |
|--------|----------|--------------------------------|
| POST   | `/login` | Login and receive a JWT token  |

---

### Users

| Method | Path                    | Description                                     |
|--------|-------------------------|-------------------------------------------------|
| GET    | `/users`                | List all users                                  |
| POST   | `/users`                | Create a new user                               |
| GET    | `/users/followings`     | Get the users that the current user is following |
| GET    | `/users/followers`      | Get the users who are following the current user |
| POST   | `/users/:id/follow`     | Follow a user by ID                             |
| DELETE | `/users/:id/unfollow`   | Unfollow a user by ID                           |

---

### Sleep Records

| Method | Path                          | Description                                                          |
|--------|-------------------------------|----------------------------------------------------------------------|
| GET    | `/sleep_records`              | Get current user's sleep records                                     |
| POST   | `/sleep_records/clock_in`     | Clock in to start a sleep record (must not already be clocked in)    |
| PATCH  | `/sleep_records/clock_out`    | Clock out from the current sleep record                              |
| GET    | `/sleep_records/followings`   | Get sleep records of followings user, filtered by timeframe and sorted by sleep duration   |


---

### Sleep

- **Clock In**: Creates a new `SleepRecord` with `clocked_in_at`
    - Fails if there's an unfinished sleep record
- **Clock Out**: Updates the latest sleep record by setting `clocked_out_at`
    - Fails if there's no active sleep record
- **Followings' Sleep Records**:
    - Can be filter by timeframe using `from` and `to` query parameters (default: last week from yesterday):
    ```
    GET /sleep_records/followings?from=2025-04-01&to=2025-04-10
    ```
    - Results are sorted by longest sleep duration

---

## List to Improve
- Database Indexing
    - Index on foreign key (followings.followed_id, followings.follower_id, sleep_records.user_id) (done)
    - Index on followings table to fast check unique records (done)
- Calculate sleep_records duration on DB level (done)
- Using PostgreSQL to handle complex data relationships (e.g. users following other users, managing sleep records) and joins
- Eager loading on some records (e.g. followings sleep records) (done)
- Pagination (done)
- Use serializer to show only desired attributes (done)
- Add more test case
- Use multithreading on Puma server
- Caching using Redis for some endpoints
- Backgound jobs using Sidekiq to calculate analytics or report if needed
- Setup Docker for easier deployment on production/staging
- Logging and monitoring system
- CI on Github to automatic run test on PR
- Scaling options
    - Horizontal (add multiple server/instance)
    - Vertical (increase size of the server/instance)
    - Add load balancer
    - Autoscaling if needed

>Note:
If you want to run on the production environment, ask the developer for `master.key`