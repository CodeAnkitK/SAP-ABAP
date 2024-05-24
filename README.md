# SAP-ABAP
 SAP ABAP on Hana Repository

## History of SAP. 

![Architecture](./img/history.jpg)

## Introduction to ABAP. 

> ABAP, which stands for Advanced Business Application Programming, is a high-level programming language created by SAP for developing business applications in the SAP environment. 

Here are some key points about ABAP:

- _Multi-Paradigm Language: _ABAP supports procedural, object-oriented, and other programming paradigms, making it versatile for various programming needs.
- _Purpose: _It is primarily used for developing applications in SAP R/3 and S/4HANA systems, including custom reports, interfaces, conversions, enhancements, and forms.
- _Integration with SAP:_ ABAP is tightly integrated with SAP's database and application environment, enabling seamless development of applications that can interact directly with the SAP data and processes.
-_ ABAP Objects:_ The introduction of ABAP Objects brought object-oriented programming capabilities to ABAP, allowing for more modular, reusable, and maintainable code.
- _Development Tools:_ Development in ABAP is typically done using the ABAP Workbench, which provides various tools for coding, debugging, and performance analysis.

ABAP remains a critical skill for SAP professionals, particularly those involved in custom development and system enhancement.

| Topic                               | Links                                                                                                                                   |
|-------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| History of SAP                      | [Link to the official page](https://www.sap.com/india/about/company/history.html)                                                       |
| Evolution of ABAP                   | [Link to the official page](https://community.sap.com/t5/enterprise-resource-planning-blogs-by-sap/evolution-of-abap/ba-p/13522761)     |
| Evolution of ABAP Programming Model | [Link to the official page](https://community.sap.com/t5/technology-blogs-by-sap/evolution-of-the-abap-programming-model/ba-p/13398328) |

---

## ERP Architecture

![Architecture](./img/erp-arch.png)

1. **Database Layer**

This is the central repository where all business data is stored. The database layer ensures data consistency and real-time access to data across the organization. It supports the various modules of the ERP system by providing a unified and integrated set of data that can be used for reporting, analysis, and operational purposes.

2. **Application Layer**

This layer hosts the actual ERP applications that process business transactions and manage data operations. It includes various functional modules such as finance, human resources, manufacturing, supply chain management, and customer relationship management. Each module is designed to support specific business functions and processes.

3. **Presentation Layer**

This is the user interface of the ERP system where users interact with the software. The presentation layer can vary widely, ranging from traditional graphical user interfaces (GUIs) like SAP GUI to modern web-based interfaces such as SAP Fiori. This layer is crucial for ensuring user accessibility and usability.

4. **Middleware**

Middleware in ERP architecture helps integrate diverse systems and applications across the enterprise. It enables communication between the ERP system and other independent systems, ensuring that there is seamless data flow and functionality across platforms. Middleware can include integration tools, application servers, and APIs.

---

## SAP Architecture

![Architecture](./img/erp-arch2.jpg "Architecture")

1. **Database Layer: **

The underlying database system where all data is stored. SAP ABAP is designed to work with any database but is optimized for SAP HANA, which allows leveraging advanced features like in-memory computing.

2. **Application Server ABAP (AS ABAP):**

This is the core of ABAP architecture, consisting of the application servers and the message server. These servers handle the execution of ABAP programs, the processing of client requests, and the management of database communications.

3. **Presentation Layer**

This consists of the client-side components that interact with the SAP system, typically SAP GUI or newer web-based interfaces like SAP Fiori. This layer is responsible for presenting the user interface to end users.

4. **Middleware**

- _Central Services:_ This includes the central services instance (ASCS), which provides essential services like enqueue and message services, vital for the management of locks and cross-application messaging.

- _Application Server ABAP (AS ABAP):_ This is the core of ABAP architecture, consisting of the application servers and the message server. These servers handle the execution of ABAP programs, the processing of client requests, and the management of database communications.

---

## SAP Module 

![Function Modules](./img/function-mod.jpg "Function Modules")

SAP modules are distinct functional components of the SAP ERP system that target specific business areas and processes. Each module is designed to handle specific business functions like finance, sales, human resources, and operations, enabling organizations to manage and integrate their business processes efficiently. Here are some of the main SAP modules:

- **SAP Financial Accounting (FI):** Manages a company's financial transactions and reporting, ensuring compliance with accounting regulations.

- **SAP Controlling (CO):** Supports monitoring, coordination, and optimization of all processes in an organization.

- **SAP Sales and Distribution (SD):** Handles all aspects of sales and distribution processing, including selling, shipping, billing, and invoicing.

- **SAP Material Management (MM):** Manages materials procurement and inventory functions, including purchasing, inventory, and warehouse management.

- **SAP Human Capital Management (HCM):** Focuses on personnel administration, payroll, recruiting, and workforce management.

---

## RICEF 

![RICEF](./img/ricef.jpg "RICEF")

> RICEF is an acronym used within SAP environments to categorize different types of development work required to enhance or customize the standard SAP system to meet specific business needs

Each letter in "RICEF" stands for a particular type of object or development task:

**R - Reports:** These are programs or tools that generate lists or other outputs based on the data within the SAP system. Reports are crucial for business analysis and decision-making processes, often created using ABAP programming.

**I - Interfaces:** Interfaces refer to the connections set up between the SAP system and external systems or between different SAP systems. These are crucial for data exchange and are often developed using various methods including BAPIs (Business Application Programming Interfaces), RFCs (Remote Function Calls), and IDocs (Intermediate Documents).

**C - Conversions:** Conversions involve the migration of data from legacy systems into an SAP environment, which is essential during initial SAP setup or when integrating new modules. This typically involves data mapping and transformation scripts.

**E - Enhancements:** Enhancements are modifications or additions to the standard SAP system to meet specific business requirements without altering the core software. This can be achieved through user exits, BADIs (Business Add-Ins), and enhancement spots.

**F - Forms:** Forms are templates used for the output of data in a structured and formatted way, such as invoices, purchase orders, and checks. SAP Script and Smart Forms are common technologies used to design and implement forms.



