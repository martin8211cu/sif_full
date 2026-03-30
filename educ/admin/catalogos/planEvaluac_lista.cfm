	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td>
		  <form name="formFiltroLista" method="post" action="planEvaluac.cfm" style="margin: 0">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
				<tr>
				  <td width="13%">Descripci&oacute;n</td>
				  <td width="73%"><input name="PEVnombre_filtro" value="<cfif isdefined('form.PEVnombre_filtro') and form.PEVnombre_filtro NEQ ''><cfoutput>#form.PEVnombre_filtro#</cfoutput></cfif>" type="text" id="PEVnombre_filtro" size="80" maxlength="80"></td>
				  <td width="14%" align="center"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Buscar"></td>
				</tr>
			  </table>			  
		  </form>
		</td>		
	  </tr>		  
	  <tr>
		<td>
			<cfif isdefined("Url.PEVnombre_filtro") and not isdefined("Form.PEVnombre_filtro")>
				<cfparam name="Form.PEVnombre_filtro" default="#Url.PEVnombre_filtro#">
			</cfif>			
			
			<cfset navegacion = "">
			<cfset filtro = "" >			
			<cfif isdefined("form.PEVnombre_filtro") and len(trim(form.PEVnombre_filtro)) gt 0>
				<cfset filtro = filtro & " and Upper(PEVnombre) like Upper('%#form.PEVnombre_filtro#%')">				
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "PEVnombre_filtro=" & Form.PEVnombre_filtro>
			</cfif>			
		
			<cfinvoke component="educ.componentes.pListas" 
					  method="pListaEdu" 
					  returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="PlanEvaluacion pe
					, PlanEvaluacionConcepto pec"/>
				<cfinvokeargument name="columnas" value="convert(varchar,pe.PEVcodigo) as PEVcodigo
					, PEVnombre
					, convert(varchar, isnull(sum(pec.PECporcentaje), 0.00)) + ' %' as PECporcentaje
					, case when sum(pec.PECporcentaje) <> 100 then '<font color=''##FF3300''><strong>INCOMPLETO</strong></font>' end as Status"
				/>
				<cfinvokeargument name="desplegar" value="PEVnombre, PECporcentaje, Status"/>
				<cfinvokeargument name="etiquetas" value="Nombre, Porcentaje, Status"/>
				<cfinvokeargument name="formatos" value=""/>
				<cfinvokeargument name="filtro" value="Ecodigo=#session.Ecodigo# 
						and pe.PEVcodigo *= pec.PEVcodigo
						#filtro#
						group by pe.PEVcodigo, PEVnombre 
					order by PEVnombre"/>
				<cfinvokeargument name="align" value="left,left,left"/>
				<cfinvokeargument name="ajustar" value="N,N"/>
				<cfinvokeargument name="formName" value="formListaPlanEvaluac"/>					
				<cfinvokeargument name="irA" value="planEvaluac.cfm"/>
				<cfinvokeargument name="Botones" value="Nuevo"/>					
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>		
		</td>
	  </tr>
	</table>