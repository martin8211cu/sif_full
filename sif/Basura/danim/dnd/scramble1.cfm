<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Untitled Document</title>

</head>

<body>
<script type="text/javascript" src="wz_dragdrop.js"></script>

<cfinclude template="pm_functions.cfm">

     <table width="549" border="0" cellpadding="4" cellspacing="4">
       <tr>
         <td width="186" valign="top">
		 <cfset pm_portlet()>
		 <cfset pm_portlet()>
</td>
         <td width="201" valign="top">
		 <cfset pm_portlet()>
		 <cfset pm_portlet()>

</td>
         <td width="122" valign="top">
		 <cfset pm_portlet()>
		 <cfset pm_portlet()>
		 <cfset pm_extra()>
		 <cfset pm_extra()>
		 <cfset pm_extra()>
</td>
         <td width="122" valign="top">
		 <cfset pm_separator()>
		 
		 <cfset pm_trace()>
		 </td>
       </tr>
     </table>
     <p>
<cfset pm_include_javascript()>
  
        </p>
</body>
</html>
