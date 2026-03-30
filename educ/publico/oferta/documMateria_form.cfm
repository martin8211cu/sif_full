<cfquery name="rsDocum" datasource="#Session.DSN#">
	Select m.Mcodigo,Mnombre,MDOcodigo,MDOtitulo,MDOdescripcion
	from Materia m
		, MateriaDocumentacion md
	where m.Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.codMcodigo#">
		and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and m.Mcodigo=md.Mcodigo
	order by MDOsecuencia
</cfquery>

<cfquery name="rsTemas" datasource="#Session.DSN#">
	Select MTEtema, MTEdescripcion
	from Materia m
		, MateriaTema mt
	where m.Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.codMcodigo#">
		and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and m.Mcodigo=mt.Mcodigo
	order by MTEsecuencia
</cfquery>

<cfinclude template="encOfertas.cfm">

<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">			
	<cfif isdefined('rsDocum') and rsDocum.recordCount GT 0>
		  <tr>
			<td colspan="3" align="center">&nbsp;</td>
		  </tr>	
		  <tr>
			<td colspan="3" align="center" class="tituloMantenimiento">#rsDocum.Mnombre#</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>	  
		  <cfloop query="rsDocum">			  	
			  <tr>
				<td width="3%">&nbsp;</td>
				<td colspan="2"><strong>#rsDocum.MDOtitulo#</strong></td>
			  </tr>  			  
			  <tr>
				<td>&nbsp;</td>
				<td width="3%">&nbsp;</td>
				<td width="94%">
					#rsDocum.MDOdescripcion#
				 </td>
			  </tr> 				  
		  </cfloop>
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>	  	      
	</cfif> 
	<cfif isdefined('rsTemas') and rsTemas.recordCount GT 0>
	  <tr>
		<td>&nbsp;</td>
		<td colspan="2" align="center" class="tituloMantenimiento">
			Temas
		</td>
	  </tr> 
	  <tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>		  
	<cfloop query="rsTemas">
		<tr>
			<td>&nbsp;</td>		
			<td colspan="2">
				<strong>#MTEtema#</strong>
			</td>
		</tr> 
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>
				#MTEdescripcion#
			</td>
		</tr> 			
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>			
	</cfloop>
	  <tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>      	  	      	  
	</cfif>
</table>
</cfoutput>