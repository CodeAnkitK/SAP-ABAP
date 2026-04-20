# Message Classes in SAP ABAP

Message classes are one of the most important features in SAP ABAP for creating clear, reusable, and maintainable user messages. Instead of hardcoding text directly in programs, ABAP developers define messages centrally and then call them wherever needed.

This approach is especially useful in business applications, where the same validation, success, warning, and error messages are used across multiple programs and screens.

## What Is a Message Class?

A message class is a collection of messages stored in SAP, usually maintained in transaction **SE91**. Each message has a number and a text, and the text can include placeholders like `&1`, `&2`, `&3`, and `&4` for dynamic values.

For example:

- `001` Employee ID is required
- `002` Employee name is required
- `003` Employee &1 saved successfully

Here, `&1` can be replaced with a value such as an employee number.

## Why Message Classes Are Used

Message classes are used because they provide several advantages:

- They keep messages centralized.
- They improve code readability.
- They make maintenance easier.
- They support translation into multiple languages.
- They encourage reuse across programs, function modules, and screens.

If a message text changes later, you update it once in the message class instead of changing many programs.

## Where Message Classes Are Created

Message classes are created in **SE91**.

Typical steps are:

1. Open transaction SE91.
2. Enter a message class name, such as `ZHR_MSG`.
3. Create the message class.
4. Add messages with numbers and texts.
5. Save and activate it.

Once created, the message class can be used in ABAP reports, module pool programs, function modules, and classes.

## Message Types in ABAP

ABAP messages can appear in different types. The message type controls how the system behaves.

### Common Message Types

| Type | Meaning | Behavior |
|---|---|---|
| `S` | Success | Shows a status message at the bottom |
| `I` | Information | Shows an informational popup |
| `W` | Warning | Warns the user, but allows continuation |
| `E` | Error | Stops processing and keeps the user on the screen |
| `A` | Abort | Stops processing immediately |
| `X` | Exit | Causes a runtime termination dump |

The most commonly used types in normal business programs are `S`, `I`, `W`, and `E`.

## Basic Syntax

A simple message statement looks like this:

```abap
MESSAGE s001.
```

If the message contains placeholders, you can pass values using `WITH`:

```abap
MESSAGE s003 WITH lv_empid.
```

If the message text is:

`Employee &1 saved successfully`

then `lv_empid` replaces `&1`.

## Example Message Class Usage

Suppose you have a message class `ZHR_MSG` with the following messages:

- `001` Employee ID is required
- `002` Employee name is required
- `003` Employee &1 saved successfully
- `004` Employee &1 not found

Then in ABAP you can write:

```abap
IF lv_empid IS INITIAL.
  MESSAGE e001(zhr_msg).
ENDIF.

MESSAGE s003(zhr_msg) WITH lv_empid.
```

This is much better than writing fixed text directly in the code.

## Message Handling in Screen Programs

Message classes are very important in dialog programming and module pool applications.

For example, in a screen’s PAI logic:

```abap
MODULE user_command_0100 INPUT.
  IF gv_empid IS INITIAL.
    MESSAGE e001(zhr_msg).
  ENDIF.
ENDMODULE.
```

If an error message of type `E` is triggered, the system stays on the same screen and the user can correct the input. This makes message classes a natural fit for validation logic.

## Placeholder Usage

ABAP messages can contain up to four placeholders:

- `&1`
- `&2`
- `&3`
- `&4`

Example message text:

`Employee &1 assigned to department &2`

Example code:

```abap
MESSAGE s010(zhr_msg) WITH lv_empid lv_dept.
```

This would replace:

- `&1` with employee ID
- `&2` with department

## Good Practices for Message Classes

Here are some practical guidelines:

- Use meaningful message class names, especially for custom development.
- Keep texts short and clear.
- Use error messages for validation.
- Use success messages after save or update actions.
- Avoid hardcoded messages in programs.
- Use one message class per application or business area when possible.

## Interview-Friendly Explanation

If someone asks you what a message class is in ABAP, you can say:

> A message class is a centralized repository of reusable messages maintained in SE91. It allows ABAP programs to display consistent success, warning, error, and information messages with support for variables and translations.

That is a strong and professional answer in interviews.

## Small Example Program

```abap
REPORT zmsg_demo.

PARAMETERS: p_empid TYPE char10.

IF p_empid IS INITIAL.
  MESSAGE e001(zhr_msg).
ENDIF.

MESSAGE s003(zhr_msg) WITH p_empid.
```

This program checks whether the employee ID is entered. If not, it raises an error. If yes, it displays a success message using the value entered by the user.

