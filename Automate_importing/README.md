# Dev Aha Moment #2

## Restoring Multiple MySQL Databases After Upgrading XAMPP

## Overview

While upgrading my development environment to support a newer **Laravel + PHP version**, I successfully backed up all my MySQL databases into `.sql` files.

However, restoring them into the **new XAMPP installation** turned out to be another challenge.

This Dev Aha Moment explains:

* The problem I encountered
* Why it happened
* The investigation process
* The final solution that restored **all databases automatically**

---

# The Problem

After installing the new XAMPP version, I attempted to restore my databases using commands like:

```
mysql -u root --database=scholardb < C:\backup\scholardb.sql
```

But MySQL returned:

```
ERROR 1049 (42000): Unknown database 'scholardb'
```

So I tried importing the SQL file without specifying a database:

```
mysql -u root < C:\backup\scholardb.sql
```

Then another error appeared:

```
ERROR 1046 (3D000): No database selected
```

At this point, it was clear that something was wrong with the SQL dump itself.

---

# Investigation

I opened one of the backup SQL files and inspected its contents.

Instead of containing instructions to create a database, the file started directly with table definitions like:

```
CREATE TABLE activity_logs (...)
```

What was missing were the statements:

```
CREATE DATABASE database_name;
USE database_name;
```

Because of this, MySQL didn't know **which database the tables should belong to**, which caused the error.

---

# The Insight

Then I realized something simple but powerful.

Each SQL file already had a **filename that matched the database name**.

Example:

```
basc_quiz.sql
inventory.sql
scholardb.sql
```

So instead of modifying the SQL file, I could simply:

1. Create a database using the **file name**
2. Import the SQL file into that database

This approach avoids editing dozens of SQL files manually.

---

# The Solution

Using a Windows command loop, I restored **all databases automatically**.

Run this inside:

```
C:\xampp_new\mysql\bin
```

Command:

```
for %f in (C:\backup\*.sql) do mysql -u root -e "CREATE DATABASE IF NOT EXISTS `%~nf`;" && mysql -u root %~nf < "%f"
```

---

# What This Command Does

For each SQL file in the backup folder:

1. Extract the filename (without `.sql`)
2. Create a database using that name
3. Import the SQL file into that database

Example process:

```
basc_quiz.sql
      ↓
CREATE DATABASE basc_quiz
      ↓
Import tables and data
```

All databases are restored automatically.

---

# Result

After running the command:

* All databases were recreated
* All tables and data were restored
* My projects ran again without errors

I verified everything through:

```
http://localhost/phpmyadmin
```

---

# Key Lesson

SQL dump files may not always include:

```
CREATE DATABASE
USE database
```

When this happens, MySQL has **no database context**, which leads to restoration errors.

Understanding this allowed me to create a **simple automation that restored dozens of databases in seconds**.

---

# Dev Aha Moment

Sometimes the solution isn't changing the SQL file.

It's understanding **what the SQL file is missing** and designing a smarter way to import it.

Small discoveries like this can significantly improve a developer's workflow.

---

📂 Repository
https://github.com/buildwithjaym/dev-aha-moments
