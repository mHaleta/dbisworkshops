/*=======================================================*/
/* Вивести користувачів, що мають більше двох продуктів  */
/*=======================================================*/

SELECT
    first_name,
    last_name
FROM
(
    SELECT
        "User".user_first_name AS first_name,
        "User".user_last_name AS last_name,
        COUNT(Advertisement.user_login)
    FROM 
        "User"
        JOIN Advertisement ON "User".user_login = Advertisement.user_login
    GROUP BY
        "User".user_first_name, "User".user_last_name
    HAVING
        COUNT(Advertisement.user_login) > 2
);