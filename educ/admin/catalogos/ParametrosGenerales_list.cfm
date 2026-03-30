<cfparam name="form.PGnombre" default="">

<!---
<cfif form.PGnombre EQ "">
	<cfif isdefined("form.modo") AND form.modo EQ "ALTA">
		<cfinclude template="conceptoEvaluac_form.cfm">
		<cfexit> 
	</cfif>
<cfelseif NOT (isdefined("form.btnLista") AND form.btnLista NEQ "" OR isdefined("form.modo") AND form.modo EQ "LISTA")>
	<cfparam name="form.modo" default="CAMBIO">
	<cfinclude template="ParametrosGenerales_form.cfm">
	<cfexit> 
</cfif>
 --->

	<table width="800" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr>
			<td width="580" valign="top">
				<cfinvoke component="educ.componentes.pListas" 
						  method="pListaEdu" 
						  returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="ParametrosGenerales"/>
					<cfinvokeargument name="columnas" value="
							  PGnombre
							, case PGgrupo
								when 10 then 'Parámetros de nomenclatura'
								when 20 then 'Tipos de matrícula permitidos'
							  end as PGgrupo
							, PGdescripcion
							, case 
								when PGtipo='B' and PGvalor='1' then 'Sí'
								when PGtipo='B' and PGvalor='0' then 'No'
								else PGvalor
							  end as PGvalor"
										/>
					<cfinvokeargument name="desplegar" value="PGdescripcion, PGvalor"/>
					<cfinvokeargument name="Cortes" value="PGgrupo"/>
					<cfinvokeargument name="etiquetas" value="Parámetro, Valor"/>
					<cfinvokeargument name="formatos"  value="V,V"/>
					<cfinvokeargument name="filtro" value="Ecodigo=#session.Ecodigo# order by PGgrupo, PGsecuencia"/>
					<cfinvokeargument name="align" value="left,left"/>
					<cfinvokeargument name="ajustar" value="S"/>
					<cfinvokeargument name="funcion" value=""/>
					<cfinvokeargument name="irA" value="ParametrosGenerales.cfm"/>
					<cfinvokeargument name="formName" value="listaParametros"/>
					<cfinvokeargument name="MaxRows" value="0"/>
				</cfinvoke>
			</td>
			<td width="20" valign="top">&nbsp;</td>
			<td width="200" valign="top">
				<cfif form.PGnombre NEQ "">
					<cfparam name="form.modo" default="ALTA">
					<cfinclude template="ParametrosGenerales_form.cfm">
				<cfelse>
					&nbsp;
				</cfif>
			</td>
		</tr>	
	</table>		  
