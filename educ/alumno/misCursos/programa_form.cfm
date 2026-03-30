<cfquery name="rsDocum" datasource="#Session.DSN#">
	Select Cnombre,Mnombre, MDOtitulo,MDOdescripcion
	from Curso c
		, Materia m
		, MateriaDocumentacion md
	where Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#">
		and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and c.Mcodigo=m.Mcodigo
		and c.Ecodigo=m.Ecodigo
		and m.Mcodigo=md.Mcodigo
	order by MDOsecuencia
</cfquery>

<cfquery name="rsTemas" datasource="#Session.DSN#">
	Select MTEtema, MTEdescripcion
	from Curso c
		, Materia m
		, MateriaTema mt
	where Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#">
		and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and c.Mcodigo=m.Mcodigo
		and c.Ecodigo=m.Ecodigo
		and m.Mcodigo=mt.Mcodigo
</cfquery>

<cfquery name="rsConcep" datasource="#Session.DSN#">
	Select CEnombre,CEdescripcion,CCEporcentaje
	from Curso c
		, CursoConceptoEvaluacion cce
		, ConceptoEvaluacion ce
	where c.Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#">
		and c.Ccodigo=cce.Ccodigo
		and cce.CEcodigo=ce.CEcodigo
	order by CCEorden
</cfquery>

<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">			
	<cfif isdefined('rsDocum') and rsDocum.recordCount GT 0>
		  <tr>
			<td colspan="3" align="center" class="tituloMantenimiento">Documentaciones</td>
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
	
	<cfif isdefined('rsConcep') and rsConcep.recordCount GT 0>
	  <tr>
		<td>&nbsp;</td>
		<td colspan="2" align="center" class="tituloMantenimiento">
			Conceptos de Evaluaci&oacute;n
		</td>
	  </tr> 
	  <tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr> 
	  <tr>
		<td>&nbsp;</td>		
		<td colspan="2">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">			  		  
				<cfloop query="rsConcep">
					  <tr>
						<td width="20%"><strong>#CEnombre#</strong></td>
						<td width="27%">(#CCEporcentaje# %) </td>
						<td width="53%">#CEdescripcion#</td>
					  </tr>
				</cfloop>
			</table>
		</td>
	  </tr>			
	
	  <tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr> 	  	  
	</cfif>	  
</table>
</cfoutput>