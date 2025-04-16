# Good Night Api

This app allows users to track when they go to bed and when they wake up. Users can follow others to see their sleep schedules and can also be followed.

See diagram [here](https://drive.google.com/file/d/1P-VDda2fN743ubPgNj_sBKheqnjpLOCA/view?usp=sharing)

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

Let me know if you want to include example requests, response formats, or setup instructions.


>Note:
If you want to run on the production environment, ask the developer for `master.key`