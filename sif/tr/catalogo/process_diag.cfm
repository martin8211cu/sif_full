<cfparam name="ProcessId">

<cfquery datasource="#session.dsn#" name="hdr">
	select k.Name as PackageName, p.Name, p.Description, p.Documentation, p.Version, p.PublicationStatus
	from WfProcess p
		join WfPackage k
			on p.PackageId = k.PackageId
	where p.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ProcessId#">
</cfquery>

<cfquery datasource="#session.dsn#" name="act">
	select a.ActivityId, a.Name as ActivityName, a.Description as ActivityDescription,
		a.StartMode, a.FinishMode, a.IsStart, a.IsFinish, a.ReadOnly,
		a.NotifySubjBefore, a.NotifySubjAfter,
		a.NotifyPartBefore, a.NotifyPartAfter,
		a.NotifyReqBefore,  a.NotifyReqAfter,
		a.NotifyAllBefore,  a.NotifyAllAfter,
		p.Name as ParticipantName, p.Description as ParticipantDescription, p.ParticipantType
	from WfActivity a
		left join WfActivityParticipant ap
			on  ap.ProcessId = a.ProcessId
			and ap.ActivityId = a.ActivityId
		left join WfParticipant p
			on p.ParticipantId = ap.ParticipantId
	where a.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ProcessId#">
	order by a.Ordering, a.ActivityId, p.Name
</cfquery>


<cfquery datasource="#session.dsn#" name="tran">
select t.FromActivity, t.ToActivity, t.Name, t.Description, t.Label,
	from_act.Name as FromActivityName, to_act.Name as ToActivityName
from WfTransition t
	join WfActivity from_act
		on t.FromActivity = from_act.ActivityId
	join WfActivity to_act
		on t.ToActivity = to_act.ActivityId
where t.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ProcessId#">
order by from_act.Name, to_act.Name
</cfquery>

<html>
<head>

<style type="text/css">
<!--
td {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 11px;
}
.style1 {
	color: #FFFFFF;
	background-color:#666666;
	font-weight: bold;
}
.style2 {
	background-color:#CCCCCC;
	font-style:italic;
}
.bordertop { border-top:1px solid black; }
.borderleft { border-left:1px solid black; }
.borderright { border-right:1px solid black; }
.borderbottom{ border-bottom:1px solid black; }
-->
</style>

</head>
<body>
<cfoutput>

<table border="0" class="bordertop borderright borderbottom borderleft" cellpadding="2" cellspacing="0" >
  <tr>
    <td colspan="2" class="style1">Detalle de tr&aacute;mite </td>
    </tr>
  <tr>
    <td valign="top">Grupo a que pertenece </td>
    <td valign="top">#hdr.PackageName#</td>
  </tr>
  <tr>
    <td valign="top">Nombre</td>
    <td valign="top">#hdr.Name#</td>
  </tr>
  <tr>
    <td valign="top">Versi&oacute;n</td>
    <td valign="top">#hdr.Version#</td>
  </tr>
  <tr>
    <td valign="top">Estado</td>
    <td valign="top">#hdr.PublicationStatus#</td>
  </tr>
  <tr>
    <td valign="top">Descripcion</td>
    <td valign="top">#hdr.Description# #hdr.Documentation#</td>
  </tr>
</table>

<br>
 <table width="500" border="0" cellpadding="2" cellspacing="0" class="borderleft borderright bordertop borderbottom">
    <tr>
      <td colspan="7" class="style1" >Transiciones</td>
    </tr>
	<tr>
        <td class="style2" >&nbsp;</td>
        <td class="style2">Origen</td>
        <td class="style2">&nbsp;</td>
        <td class="style2">Destino</td>
        <td class="style2">Nombre</td>
        <td class="style2">Etiqueta</td>
        <td class="style2">Descripcion</td>
   </tr>
    <cfloop query="tran">
      <tr>
        <td>&nbsp;</td>
        <td>#tran.FromActivityName#  </td>
        <td>&rarr;</td>
        <td>#tran.ToActivityName#</td>
        <td>#tran.Name#</td>
        <td>#tran.Label#</td>
        <td>#tran.Description#</td>
      </tr>
    </cfloop>
</table> 
</cfoutput>
<table width="500" border="0" cellpadding="2" cellspacing="0">
  <!--DWLayoutTable-->
<tr>
  <td width="3" valign="top" nowrap><!--DWLayoutEmptyCell-->&nbsp;</td>
  <td width="91" valign="top" nowrap><!--DWLayoutEmptyCell-->&nbsp;</td>
  <td width="173" valign="top" nowrap><!--DWLayoutEmptyCell-->&nbsp;</td>
  <td width="217" valign="top" nowrap><!--DWLayoutEmptyCell-->&nbsp;</td>
  </tr>
<cfoutput query="act" group="ActivityId">
<tr>
  <td colspan="4" valign="top" nowrap class="borderright bordertop borderleft style1">Actividad No #act.ActivityId# - #act.ActivityName#</td>
    </tr>
<tr>
  <td rowspan="3" class="borderleft">&nbsp;</td>
  <td colspan="3" class="borderright">StartMode: #act.StartMode#
    </td>
  </tr>
<tr>
  <td colspan="3" class="borderright">FinishMode: #act.FinishMode#</td>
  </tr>
<tr>
  <td colspan="3" class="borderright">Flags: 
    <cfif act.IsStart>
          IsStart
      </cfif>
        <cfif act.IsFinish>
      IsFinish
        </cfif>
        <cfif act.ReadOnly>
      ReadOnly
      </cfif>
	  <cfif Not (act.IsStart Or act.IsFinish Or act.Readonly)>Ninguna</cfif>
	  </td>
  </tr>
<cfif Len(act.ParticipantType)>
<tr>
  <td class="style2 borderleft">&nbsp;</td>
  <td valign="top" class="style2">Tipo</td>
	  <td valign="top" class="style2">C&oacute;digo</td>
	  <td valign="top" class="style2 borderright">Participante</td>
	  </tr><cfoutput>
<tr>
  <td class="borderleft">&nbsp;</td>
  <td valign="top">
	  <cfset PartType = ListGetAt(act.ParticipantType & ',USUARIO,C. FUNCIONAL,GRUPO,ROL,JEFE', 1+ListFindNoCase('HUMAN,ORGUNIT,GROUP,ROLE,BOSS',act.ParticipantType))>
	  #PartType#</td>
      <td valign="top">#act.ParticipantName#</td>
      <td valign="top" class="borderright">#act.ParticipantDescription#</td>
    </tr>
      </cfoutput>
</cfif>
<tr>
  <td class="bordertop" height="1" colspan="4">&nbsp;</td>
  </tr>
</cfoutput>
</table>

</body></html>