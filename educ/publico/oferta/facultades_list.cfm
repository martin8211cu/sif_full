<cfquery datasource="#Session.DSN#" name="rsParam">
	select p2.PGvalor as Introduccion 
	from ParametrosGenerales p2
	where p2.PGnombre='OfertaAca1'
</cfquery>
<cfquery datasource="#Session.DSN#" name="rsFacultades">
	Select distinct f.Fcodigo,Fcodificacion,Fnombre
	from PlanEstudios p
		, Carrera c
		, Escuela e
		, Facultad f
	where f.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
	  and f.Fcodigo = e.Fcodigo
	  and e.EScodigo = c.EScodigo
	  and c.CARcodigo = p.CARcodigo
	  and p.PESestado = 1
	  and convert(varchar,getdate(),112) between
			convert(varchar,p.PESdesde,112) and
			convert(varchar,isnull(p.PEShasta,getdate()),112)
	order by Fnombre
</cfquery>

<cfif isdefined('rsFacultades') and rsFacultades.recordCount GT 0>
	<cfoutput>
		<form name="formFacultades" method="post" action="oferta.cfm">
			<input type="hidden" name="Fcodigo" value="">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			  <tr>
				<td colspan="3">
				  <h4>#rsParam.Introduccion#</h2>
				</td>
			  </tr>
			  <tr>
				<td colspan="3" align="center"><hr></td>
			  </tr>			  
			  <cfloop query="rsFacultades">
				<tr style="cursor: pointer" onClick="javascript: ProcesaReg('#rsFacultades.Fcodigo#');" class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
				  <td width="3%">&nbsp;</td>
				  <td colspan="2"><strong><font color="##0000FF" size="2">#rsFacultades.Fnombre#
						(#rsFacultades.Fcodificacion#)</font></strong></td>
				</tr>
			  </cfloop>
			  <tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>
			  <tr>
				<td colspan="3"><hr>
				</td>
			  </tr>
			</table>
	      </form>
	</cfoutput>	  
<cfelse>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td colspan="3" align="center">
				<strong>No existen Planes de Estudios Disponibles</strong>
			</td>
		</tr>	
	</table>	
</cfif>

<script language="JavaScript" type="text/javascript">
	function ProcesaReg(cod){
		if(cod != ''){
			document.formFacultades.Fcodigo.value = cod;
			document.formFacultades.submit();
		}		
	}
</script>