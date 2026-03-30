<cfset LB_title="Desactualizar Masivo">
<title><cfoutput>#LB_title#</cfoutput></title>

<cf_templatecss>
<cf_web_portlet_start titulo="#LB_title#">


<!-------PERIODO-------->
<cfquery name="rsPeriodos" datasource="#session.dsn#">
	select distinct Speriodo as value , <cf_dbfunction name="to_char" args="Speriodo">  as description  
	from CGPeriodosProcesados
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"/>
	order by value
</cfquery>
<cfif isdefined("form.GATPeriodo") and len(trim(form.GATPeriodo))> 
	<cfset per_selec="#form.GATPeriodo#">
<cfelse>
	<cfquery name="rsPeriodoAux" datasource="#session.dsn#"> 
		select Pvalor, Pdescripcion 
		from Parametros 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"/> 
		  and Pcodigo = 50 
	</cfquery>
	<cfset per_selec="#rsPeriodoAux.Pvalor#">
</cfif>
<!-------MES------->
<cfquery name="rsMeses" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="VSvalor"> as value, VSdesc as description
	from VSidioma vs
		inner join Idiomas id
		on id.Iid = vs.Iid
		and id.Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Idioma#"/>
	where VSgrupo = 1
	order by 1
</cfquery>
<cfif isdefined("form.GATMes") and len(trim(form.GATMes))> 
	<cfset mes_selec="#form.GATMes#">
<cfelse>
	<cfquery name="rsMesAux" datasource="#session.dsn#">
		select Pvalor, Pdescripcion 
		from Parametros 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"/> 
		 and Pcodigo = 60 
	</cfquery>
	<cfset mes_selec="#rsMesAux.Pvalor#">
</cfif>

<!---Filtro conceptos--->
<cfquery name="rsConceptos" datasource="#session.dsn#">
	select distinct(a.Cconcepto) as value, a.Cdescripcion as description, 0 as orden
	from ConceptoContableE a
	  inner join GATransacciones b 
	   on a.Cconcepto = b.Cconcepto
	   and b.GATperiodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#per_selec#">
	   and b.GATmes=	  <cfqueryparam cfsqltype="cf_sql_numeric" value="#mes_selec#">
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by 3,2
</cfquery>
<cfif isdefined("form.Cconcepto") and len(trim(form.Cconcepto))> 
	<cfset con_selec="#form.Cconcepto#">
<cfelse>
	<cfset con_selec="#rsConceptos.value#">
</cfif>
<!---Filtro Documentos--->
<cfquery name="rsDocumentos" datasource="#session.dsn#">
	select distinct(Edocumento) 
	from GATransacciones
	where Edocumento is not null
	and GATperiodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#per_selec#">
	and GATmes=<cfqueryparam cfsqltype="cf_sql_numeric" value="#mes_selec#">
    <cfif isdefined("con_selec") and len(trim(con_selec))> 
	and Cconcepto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#con_selec#">
    </cfif>
	order by Edocumento
</cfquery>
<cfoutput>

<form action="Desactualizar-sql.cfm" method="post" name="form1">

	<table width="100%" border="0"  cellpadding="6">
	   <tr>
		<td width="100%" align="center" valign="top">	
			Esta opción reversa el proceso de Actualización </p>				
		</td>
	   </tr>
	   <tr>
		<td>
		<table width="100%" border="0"  cellpadding="6">
				<tr>
				<td width="50%" align="right"><strong>Periodo:</strong></td>
				<td width="50%">
				<select name="GATPeriodo" tabindex="1" onchange="document.form1.submit()">
					<cfloop query="rsPeriodos">
						<option value="#rsPeriodos.value#" <cfif isdefined("per_selec") and per_selec eq rsPeriodos.value>selected</cfif> >#rsPeriodos.description#</option>
					</cfloop>
				</select>
				</td>
				</tr>
				<tr>
					<td align="right"><strong>Mes:</strong></td>
					<td>
						<select name="GATMes" tabindex="2" onchange="document.form1.submit()">
							<cfloop query="rsMeses">
								<option value="#rsMeses.value#" <cfif isdefined("mes_selec") and mes_selec eq rsMeses.value>selected</cfif> >#rsMeses.description#</option>
							</cfloop>
						</select>		
					</td>
				</tr>
				<tr>
					<td align="right"><strong>Concepto:</strong></td>
					<td>
						<select name="Cconcepto" tabindex="3" onchange="document.form1.submit()">
							<cfloop query="rsConceptos">
								<option value="#rsConceptos.value#" <cfif isdefined("con_selec") and con_selec eq rsConceptos.value>selected</cfif>>#rsConceptos.description#</option>
							</cfloop>
						</select>			
					
					</td>
				</tr>	
				<tr>
					<td align="right"><strong>Documento:</strong></td>
					<td>
						<select name="Documento" tabindex="3">
							<cfloop query="rsDocumentos">
								<option value="#rsDocumentos.Edocumento#">#rsDocumentos.Edocumento#</option>
							</cfloop>
						</select>			
					
					</td>
				</tr>	
				<tr>
				<td colspan="2" align="center">
				
				
				<input name="btnDesactualizar" type="submit" value="Desactualizar" tabindex="4" onClick="javascript:return Validar();" >
				<input name="btnCerrarDOWN" type="button" value="Cerrar" onClick="javascript:window.close();" tabindex="5"></td>
				</tr>
				
			</table>
		
		</td>	
	</tr>
	</table>
		
	</form>
</cfoutput>
<cf_web_portlet_end>
<script language="javascript" type="text/javascript">
		function Validar()
		{
			if(document.form1.Documento.value =="")
			{
				alert('Debe seleccionar un documento antes de Aplicar');
				return false;
			}
			else 
			{
				if(confirm("Est seguro de que desea desactualizar el documento seleccionado?"))
				{ document.form1.btnDesactualizar.submit(); return true;}

			}
			
		}	
</script>

