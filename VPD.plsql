-- All of Employees (without Department chief, Branch manager, Project manager)
-- Only them can view thier informations and others in thier department, and viewing thier salaries

-- Create VPD Policy Function 
create or replace function view_Inform_Salary(p_schema varchar2, p_obj varchar2) 
  return varchar2
  as 
    UserID varchar2(200);
  begin  
    UserID := 'SYS_CONTEXT("USERENV","SESSION_USER")';
    if(UserID like 'NV%') then
      return 
        'Atbmhttt_lab01.Employee.EmployeeID in (select EmployeeID from Atbmhttt_lab01.Employee where EmployeeID = ' || UserID ||')' || 
        'Atbmhttt_lab01.Branch.BranchManager in (select BranchManager from Atbmhttt_lab01.Branch where BranchManager != ' || UserID || ')' ||
        'Atbmhttt_lab01.Department.DepartmentChief in (select DepartmentChief from Atbmhttt_lab01.Department where DepartmentChief != ' || UserID || ')' ||
        'Atbmhttt_lab01.Projects.ProjectManager in (select ProjectManager from Atbmhttt_lab01.Projects where ProjectManager != ' || UserID || ')';
    else
      return null;
    end if;
  end view_Inform_Salary;
  
-- Assigning Policy function 
begin
dbms_rls.add_policy 
(
  object_schema     => 'Atbmhttt_lab01', 
  object_name       => 'Employee', 
  policy_name       => 'view_Inform_Salary_VPD', 
  function_schema   => 'Atbmhttt_lab01', 
  policy_function   => 'view_Inform_Salary', 
  statement_types   => 'select, update, insert, delete', 
  sec_relevant_cols => 'Salary',
  update_check      => TRUE
);
end;


