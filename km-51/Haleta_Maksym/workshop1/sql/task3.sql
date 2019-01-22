/*=======================================================*/
/* Видалити користувачів, що мають три продукти          */
/*=======================================================*/

DELETE FROM "User"
WHERE
    "User".user_login IN
    (
        SELECT
            user_login
        FROM
        (
            SELECT
                user_login,
                COUNT(user_login)
            FROM
                Advertisement
            GROUP BY
                user_login
            HAVING
                COUNT(user_login) = 3
        )
    );