<cfquery datasource="#Session.DSN#" name="rsParam">
	select p1.PGvalor as Facultad, p2.PGvalor as Escuela, p3.PGvalor as Introduccion 
	from ParametrosGenerales p1, ParametrosGenerales p2, ParametrosGenerales p3
	where p1.PGnombre='Facultad' and p2.PGnombre='Escuela' and p3.PGnombre='OfertaAca2'
</cfquery>
<cfquery datasource="#Session.DSN#" name="rsPlanes">	
	select 
		ps.Scodigo
		, ('Sede: '+ Snombre) as Snombre
		, Fnombre
		, c.EScodigo 
		, '#rsParam.Escuela#: '+ESnombre as ESnombre
		, ESnombre as ESnombre2
		, c.CARcodigo 
		, 'Carrera: '+CARnombre as CARnombre
		, CARnombre as CARnombre2
		, p.PEScodigo
		, GAnombre + ' en ' + PESnombre as PESnombre
	from PlanEstudios p
		, Carrera c
		, Escuela e
		, Facultad f
		, GradoAcademico g
		, PlanSede ps
		, Sede s		
	where f.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
		  and f.Fcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Fcodigo#"> 
			<cfif isdefined('form.cbScodigo') and form.cbScodigo NEQ '' and form.cbScodigo NEQ '-1'>
				and ps.Scodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cbScodigo#"> 
			</cfif>	
		  and f.Fcodigo = e.Fcodigo
		  and e.EScodigo = c.EScodigo
		  and c.CARcodigo = p.CARcodigo
		  and p.GAcodigo *= g.GAcodigo
		  and p.PESestado = 1
		  and convert(varchar,getdate(),112) between
			convert(varchar,p.PESdesde,112) and
			convert(varchar,isnull(p.PEShasta,getdate()),112)
		and p.PEScodigo=ps.PEScodigo
		and ps.Scodigo=s.Scodigo
	order by c.CARcodigo, GAorden desc
</cfquery>

<cfset poneEscuela = true>

<cfif isdefined('rsPlanes') and rsPlanes.recordCount GT 0>
	<cfquery name="rsNumEscuelas" dbtype="query">	<!--- Primer caso --->
		Select distinct EScodigo, ESnombre2,Fnombre
		from rsPlanes
	</cfquery>

	<cfif isdefined('rsNumEscuelas') and rsNumEscuelas.recordCount EQ 1>	<!--- Solo hay una escuela --->
		<cfif rsNumEscuelas.ESnombre2 EQ rsNumEscuelas.Fnombre>
			<cfset poneEscuela = false>
		</cfif>
	</cfif>
	<cfif poneEscuela EQ true>	<!--- Segundo caso --->
		<cfquery name="rsEscCarr" dbtype="query">
			Select count(*) as cant
			from rsPlanes
			where ESnombre2 <> CARnombre2
		</cfquery>	
		<cfif isdefined('rsEscCarr') and rsEscCarr.cant GT 0 and rsEscCarr.cant NEQ "">
			<cfset poneEscuela = true>
		<cfelse>
			<cfset poneEscuela = false>
		</cfif>
	</cfif>
</cfif>

<cfquery datasource="#Session.DSN#" name="rsSedes">
	Select Scodigo,Snombre
	from Sede
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
	order by Sorden
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td width="43%">&nbsp;</td>
	<td width="2%">&nbsp;</td>
	<td width="55%">&nbsp;</td>
  </tr>
  <tr>
	<td colspan="3"><h5><cfoutput>#rsParam.Introduccion#</cfoutput></h5></td>
  </tr>
  <tr>
	<td colspan="3">		 
	 	<form name="form1" method="post" action="oferta.cfm" style="margin: 0">
			<input type="hidden" name="Fcodigo" value="<cfoutput>#form.Fcodigo#</cfoutput>">
			
			<strong>Sede</strong>:
			<cfif isdefined('rsSedes') and rsSedes.recordCount GT 0>
				<cfif isdefined('rsSedes') and rsSedes.recordCount GT 1>
					<select name="cbScodigo" id="cbScodigo" onChange="this.form.submit();">
						<option value="-1">-- TODAS --</option>		
						<cfoutput query="rsSedes">
							<option value="#rsSedes.Scodigo#" <cfif isdefined('form.cbScodigo') and form.cbScodigo EQ rsSedes.Scodigo> selected</cfif>>#rsSedes.Snombre#</option>
						</cfoutput>			
					</select>	
				<cfelse>
					<strong><cfoutput><font size="3">#rsSedes.Snombre#</font></cfoutput></strong>
				</cfif>
			</cfif>
		</form>
	</td>
  </tr>
</table>
	
<cfif isdefined('rsPlanes') and rsPlanes.recordCount GT 0>
	<cfset escuela = "">
	<cfset sede = "">	
	<cfset carrera = "">	
	<cfset plan = "">
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<cfoutput>
		<td class="tituloMantenimiento">#rsParam.Facultad#: #rsPlanes.Fnombre#</td>
		</cfoutput>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>	  
  	</table>
	<form name="formLista" method="post" action="oferta.cfm" style="margin: 0">
		<cfoutput>	
			<input type="hidden" name="Fcodigo" value="#form.Fcodigo#">
			<input type="hidden" name="PEScodigo" value="">
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<cfloop query="rsPlanes">
					<cfif isdefined('rsSedes') and rsSedes.recordCount GT 1>
						<cfif not isdefined('form.cbScodigo') or form.cbScodigo EQ '-1'>
							<cfif sede NEQ rsPlanes.Scodigo>
								  <tr>
									<td width="0%" bgcolor="##D9E1CC">&nbsp;</td>
									<td colspan="4" bgcolor="##D9E1CC"><strong><font color="##000000" size="2">#rsPlanes.Snombre#</font></strong></td>
								  </tr>
								<cfset sede = rsPlanes.Scodigo>
							</cfif>			
						</cfif>
					</cfif>
<!--- 					<cfif (rsPlanes.ESnombre2 NEQ rsPlanes.Fnombre) and (rsPlanes.ESnombre2 NEQ rsPlanes.CARnombre2)> --->
					<cfif poneEscuela EQ true>					
						<cfif escuela NEQ rsPlanes.EScodigo>
							  <tr>
								<td width="0%">&nbsp;</td>
								<td width="0%">&nbsp;</td>
								<td colspan="3"><strong>#rsPlanes.ESnombre#</strong></td>
							  </tr>
							<cfset escuela = rsPlanes.EScodigo>
						</cfif>
					</cfif>
					
					<cfif carrera NEQ rsPlanes.CARcodigo>
						  <tr>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td width="2%">&nbsp;</td>
							<td colspan="2"><strong><font color="##000000" size="2">#rsPlanes.CARnombre#</font></strong></td>
						  </tr>				
						  <cfset carrera = rsPlanes.CARcodigo>
					</cfif>	
					<cfif plan NEQ rsPlanes.PEScodigo>
						
						  <tr style="cursor: pointer" onClick="javascript: Procesar('#rsPlanes.PEScodigo#');" class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td width="1%">&nbsp;</td>
							<td width="97%"><strong><font color="##0000FF" size="2">#rsPlanes.PESnombre#</font></strong></td>
						  </tr>	
						<cfset plan = rsPlanes.PEScodigo>
					</cfif>	
				</cfloop>
	
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
			</table>
		</cfoutput>			
	</form>
<cfelse>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td width="43%">&nbsp;</td>
		<td width="2%">&nbsp;</td>
		<td width="55%">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="43%">&nbsp;</td>
		<td width="2%">&nbsp;</td>
		<td width="55%">&nbsp;</td>
	  </tr>	  
	  <tr>
		<td colspan="3" align="center"><strong><font size="2">No hay Planes de Estudio disponibles</font></strong></td>
	  </tr>
  	</table>	
</cfif>

<script language="JavaScript" type="text/javascript">
	function Procesar(codPlan){
		if(codPlan != ''){
			document.formLista.PEScodigo.value = codPlan;
			document.formLista.submit();
		}
	}
</script>