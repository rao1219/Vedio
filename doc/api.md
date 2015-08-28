FORMAT: 1A
HOST: http://start.vsvs.tunel.edu.cn/api

# Very simple video site

What you see is what you get.

## Convention

### PUT and POST

* PUT idempotent.
* POST not idempotent.

### HTTP status code

| status code | meaning      |
|-------------|--------------|
| 200         | OK           |
| 202         | Created      |
| 401         | Unauthorized |
| 403         | Forbidden    |

# Group Session

## Login [/session/login]

### Login [POST]

+ Request (application/json)

    + Attributes (object, fixed)
        + username: *admin*(string)
        + password: *change me*(string)

+ Response 200 (text/plain; charset=utf-8)

    + Headers

            Set-Cookie: {cookie}

    + Body

            Welcome

## Session view [/session/me]

### Get session [GET]

+ Response 200 (application/json; charset=utf-8)

    + Attributes (object, fixed)
        + id: *1*(number)
        + role (enum)
            + admin
            + uploader
            + reviewer
            + viewer
        + username: *admin*(string)

## Session destruction [/session/logout]

### Logout [POST]

+ Response 200 (text/plain; charset=utf-8)

        Bye

# Group User

## User [/user/{id}]

+ Parameters
    + id: 4 (required, number) - user id number

### Get detailed user profile [GET]

> @admin @me

+ Response 200 (application/json; charset=utf-8)

    + Attributes (object, fixed)
        + username: *admin*(string)
        + id: *1*(number)
        + role (enum)
            + admin
            + uploader
            + reviewer
            + viewer
        + createdAt: *1437011332000*(EPOCH)

### Update user profile [PATCH]

> @admin @me

+ Request (application/json)

    + Attributes (object, fixed)
        + password: *password after changed*(string)
        + role (enum)
            + admin
            + uploader
            + reviewer
            + viewer

+ Response 200 (text/plain; charset=utf-8)

        Updated

### Delete user [DELETE]

> @admin

+ Response 200 (text/plain; charset=utf-8)

        Success

## Users [/user{?page,limit}]

+ Parameters
    + page: 1 (number, required) - page number
    + limit: 20 (number, optional) - max number of items per page(Maximum: 100)
        + Default: 20

### Get user list [GET]

+ Response 200 (application/json; charset=utf-8)

    + Attributes (object, fixed)
        + users(array) - users of current page
            + (object, fixed)
                + username: *admin*(string)
                + id: *1*(number)
                + role (enum)
                    + admin
                    + uploader
                    + reviewer
                    + viewer
        + total: *300* (number) - total number of users

## New user [/user]

### Create new user [POST]

+ Request (application/json)

    + Attributes (object, fixed)
        + username: *MrA1*(string) - a non-existent username
        + password: *dfc1ae22066aed*(string)
        + role(enum, optional) - role of user
            + Default: viewer
            + admin (string)
            + reviewer (string)
            + uploader (string)
            + viewer (string)

+ Response 202 (text/plain; charset=utf-8)

    + Headers

            Location: /user/{id}

    + Body

            Created

+ Request (application/json)

    + Attributes (object, fixed)
        + username: *admin*(string) - an existent username(alphanumeric)
        + password: *dfc1ae22066aed*(string)
        + role(enum, optional) - role of user
            + Default: viewer
            + admin (string)
            + reviewer (string)
            + uploader (string)
            + viewer (string)

+ Response 409 (application/json; charset=utf-8)

    + Attributes (object, fixed)
        + conflicts (array)
            + *name* (string, fixed)

# Group Video

## New video [/video]

+ Attributes (object)
    + status (enum) - status of video
        + new
        + uploading
        + uploaded

### Try to create new video [POST]

+ Request (application/json)

    + Attributes (Video Identifier)

+ Response 200 (application/json; charset=utf-8)

    + Headers

            Location: /video/{id}

    + Attributes (New video)

## Video [/video/{id}]

+ Parameters
    + id: 1 (required, number) - id number of video

### Delete video [DELETE]

+ Response 202 (text/plain; charset=utf-8)

        Success

## Video File [/video/{id}/file]

+ Parameters
    + id: 1 (required, number) - id number of video

### Upload video [PUT]

upload video file with some method

+ Request (video/whatever)

+ Response 200 (text/plain; charset=utf-8)

        Ok

+ Response 400 (text/plain; charset=utf-8)

        Hash not match / Size not match

### Play video [GET]

+ Response 200 (video/whatever; charset=utf-8)

## Video Meta Info [/video/{id}/meta]

+ Parameters
    + id: 1 (required, number) - id number of video

### Get meta info [GET]

+ Response 200 (application/json; charset=utf-8)

    + Attributes (Video)
        + Include Time Mixin

### Update meta info [PUT]

+ Request (application/json)

    + Attributes (Video)

+ Response 200 (text/plain; charset=utf-8)

        Ok

## Videos [/video{?page,limit}]

+ Parameters
    + page: 1 (number, required) - page number
    + limit: 20 (number, optional) - max number of items per page(Maximum: 100)
        + Default: 20

+ Attributes (object)
    + users (array[Video]) - videos of current page
    + total: 300 (number) - total number of users

### Get video list [GET]

+ Response 200 (application/json; charset=utf-8)

    + Attributes (Videos)


# Data Structure

## Extended Primitive Types

### EPOCH (number)

        milliseconds since 1970-01-01 00:00:00 UTC

### URL (string)

        uniform resource locator

### Hash (string)

        hash value

### Role (enum[string])

+ admin
+ reviewer
+ uploader
+ viewer

## Mixins

### Time Mixin (object)
+ createdAt:1437011332000 (EPOCH)
+ updatedAt:1437011346000 (EPOCH)

## Objects

### Basic Model (object)
+ id: 1 (number) - user id number

### Login (object)

+ username: admin (string) - user id number
+ password: change me (string) - username of user

### User (Basic Model)

+ username: admin (string) - username of user
+ role (enum) - role of user
    - admin (string)
    - reviewer (string)
    - uploader (string)
    - viewer (string)

### Profile (User)

+ avatar: http://www.gravatar.com/avatar/xxxx.png (URL)

### Video Identifier (object)

+ size: 512 (number)
+ hash: 70924d6fa4b2d745185fa4660703a5c0 (Hash)

### Video (Basic Model)

+ uploader: 1 (number) - user id number of uploader
