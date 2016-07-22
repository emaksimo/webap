# POST /api/v1/auth/signup

+ Request (application/json)

    + Headers

            Cookie: sessionId=s%3AYytNnRGyncpxXV_7eFI6iZkG2tnCV-pZ.wqrEmYT%2BfmR8eFehd6NWFxTb%2FXbCBBZMckNvYGbAHlk; boldr:sid=s%3AHuvn7qy-RPrUdhNq2eY4nVC4oTiMU5iH.sDIFykyhmV71EmtXeYRo%2B0%2FVLnmnPkTFaWOizgkunUs

    + Body

            {
                "email": "boldr@boldr.io",
                "password": "password",
                "name": "Boldr CMS",
                "displayName": "Boldr",
                "location": "Colorado",
                "website": "https://boldr.io",
                "gender": "Male",
                "bio": "A bold take on content management systems"
            }

+ Response 200 (application/json; charset=utf-8)

    + Headers

            Access-Control-Allow-Origin: *
            Etag: W/"33-3GF762J7wA37Vu3gQ84wrQ"
            Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
            Set-Cookie: sessionId=s%3AYytNnRGyncpxXV_7eFI6iZkG2tnCV-pZ.wqrEmYT%2BfmR8eFehd6NWFxTb%2FXbCBBZMckNvYGbAHlk; Path=/; HttpOnly
            X-FRAME-OPTIONS: SAMEORIGIN
            X-XSS-Protection: 1; mode=block
            Vary: X-HTTP-Method-Override, Accept-Encoding

    + Body

            {"message":"Your account has been created and you are now logged in."}

            # POST /api/v1/auth/login

            + Request (application/json)

                + Headers

                        Cookie: sessionId=s%3AYytNnRGyncpxXV_7eFI6iZkG2tnCV-pZ.wqrEmYT%2BfmR8eFehd6NWFxTb%2FXbCBBZMckNvYGbAHlk; boldr:sid=s%3AHuvn7qy-RPrUdhNq2eY4nVC4oTiMU5iH.sDIFykyhmV71EmtXeYRo%2B0%2FVLnmnPkTFaWOizgkunUs

                + Body

                        {
                          "email": "boldr@boldr.io",
                          "password": "password"
                        }

            + Response 200 (application/json; charset=utf-8)

                + Headers

                        Access-Control-Allow-Origin: *
                        Etag: W/"d9-TlDPNLqog/zKv0DGUBKPLg"
                        Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
                        Set-Cookie: boldr:sid=s%3AHuvn7qy-RPrUdhNq2eY4nVC4oTiMU5iH.sDIFykyhmV71EmtXeYRo%2B0%2FVLnmnPkTFaWOizgkunUs; Path=/; HttpOnly
                        X-FRAME-OPTIONS: SAMEORIGIN
                        X-XSS-Protection: 1; mode=block
                        Vary: X-HTTP-Method-Override, Accept-Encoding

                + Body

                        {"token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImNmYzNmZWQxLTlkNDQtNDc2NC1iZjExLWU2NDk2ODZlNjc0MiIsInJvbGUiOiJ1c2VyIiwiaWF0IjoxNDY4MTk3MTU4LCJleHAiOjE0NjgyMDA3NTh9.kISmtRB7rJE4-8nlBkCNyuXpQbxS_liGUk_a_iOUxvw"}
                        # GET /api/v1/users/me

                        + Request

                            + Headers

                                    Cookie: sessionId=s%3AYytNnRGyncpxXV_7eFI6iZkG2tnCV-pZ.wqrEmYT%2BfmR8eFehd6NWFxTb%2FXbCBBZMckNvYGbAHlk; boldr:sid=s%3AHuvn7qy-RPrUdhNq2eY4nVC4oTiMU5iH.sDIFykyhmV71EmtXeYRo%2B0%2FVLnmnPkTFaWOizgkunUs
                                    Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImNmYzNmZWQxLTlkNDQtNDc2NC1iZjExLWU2NDk2ODZlNjc0MiIsInJvbGUiOiJ1c2VyIiwiaWF0IjoxNDY4MTk3MTU4LCJleHAiOjE0NjgyMDA3NTh9.kISmtRB7rJE4-8nlBkCNyuXpQbxS_liGUk_a_iOUxvw



                        + Response 200 (application/json; charset=utf-8)

                            + Headers

                                    Etag: W/"d6-0tt8yzvGDzM7DYR9yE9jrw"
                                    Vary: Accept-Encoding
                                    Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
                                    X-FRAME-OPTIONS: SAMEORIGIN
                                    X-XSS-Protection: 1; mode=block
                                    Access-Control-Allow-Origin: *

                            + Body
                                    {   
                                        "id":"cfc3fed1-9d44-4764-bf11-e649686e6742",
                                        "email": "boldr@boldr.io",
                                        "profile": {
                                          "name": "Boldr CMS",
                                          "displayName": "Boldr",
                                          "location": "Colorado",
                                          "website": "https://boldr.io",
                                          "gender": "Male",
                                          "bio": "A bold take on content management systems",
                                          "role": "User"
                                      }
                                    }
                                    # GET /api/v1/users/cfc3fed1-9d44-4764-bf11-e649686e6742

                                    + Request

                                        + Headers

                                                Cookie: sessionId=s%3AYytNnRGyncpxXV_7eFI6iZkG2tnCV-pZ.wqrEmYT%2BfmR8eFehd6NWFxTb%2FXbCBBZMckNvYGbAHlk; boldr:sid=s%3AHuvn7qy-RPrUdhNq2eY4nVC4oTiMU5iH.sDIFykyhmV71EmtXeYRo%2B0%2FVLnmnPkTFaWOizgkunUs
                                                Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImNmYzNmZWQxLTlkNDQtNDc2NC1iZjExLWU2NDk2ODZlNjc0MiIsInJvbGUiOiJ1c2VyIiwiaWF0IjoxNDY4MTk3MTU4LCJleHAiOjE0NjgyMDA3NTh9.kISmtRB7rJE4-8nlBkCNyuXpQbxS_liGUk_a_iOUxvw



                                    + Response 200 (application/json; charset=utf-8)

                                        + Headers

                                                Etag: W/"d6-0tt8yzvGDzM7DYR9yE9jrw"
                                                Vary: Accept-Encoding
                                                Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
                                                X-FRAME-OPTIONS: SAMEORIGIN
                                                X-XSS-Protection: 1; mode=block
                                                Access-Control-Allow-Origin: *

                                        + Body

                                        {   
                                            "id":"cfc3fed1-9d44-4764-bf11-e649686e6742",
                                            "email": "boldr@boldr.io",
                                            "profile": {
                                              "name": "Boldr CMS",
                                              "displayName": "Boldr",
                                              "location": "Colorado",
                                              "website": "https://boldr.io",
                                              "gender": "Male",
                                              "bio": "A bold take on content management systems",
                                              "role": "User"
                                          }
                                        }
