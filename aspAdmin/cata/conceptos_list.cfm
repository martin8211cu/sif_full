<cfoutput>
	<cfset filtro = "1=1">		
	
	<cfif isdefined("form.btnFiltrar") and isdefined("form.fLOCnombre") and len(trim(form.fLOCnombre)) gt 0>
		<cfset filtro = filtro & " and upper(LOCnombre) like upper('%#form.fLOCnombre#%')" >
	</cfif> 
	<cfif isdefined("form.btnFiltrar") and isdefined("form.fLOCtipo") and len(trim(form.fLOCtipo)) gt 0 and form.fLOCtipo NEQ '-1'>
		<cfset filtro = filtro & " and upper(LOCtipo) = upper('#form.fLOCtipo#')" >
	</cfif> 				

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td>
			<form name="form1" method="post" action="conceptos.cfm" style="margin: 0">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
				  <tr>
					<td width="10%" align="right"><strong>Nombre:</strong></td>
					<td width="24%"><input name="fLOCnombre" type="text" id="fLOCnombre" size="40" maxlength="40" value="<cfif isdefined('form.fLOCnombre') and form.fLOCnombre NEQ ''>#form.fLOCnombre#</cfif>">
					</td>
					<td width="2%">&nbsp;</td>
					<td width="7%" align="right"><strong>Tipo:</strong></td>
					<td width="18%">
						<select name="fLOCtipo" id="fLOCtipo">
							<option value="-1" <cfif isdefined('form.fLOCtipo') and form.fLOCtipo EQ '-1'> selected</cfif>>-- Todos --</option>							
							<option value="I" <cfif isdefined('form.fLOCtipo') and form.fLOCtipo EQ 'I'> selected</cfif>>Lista por Idiomas</option>
							<option value="P" <cfif isdefined('form.fLOCtipo') and form.fLOCtipo EQ 'P'> selected</cfif>>Lista por Pa&iacute;s</option>
							<option value="V" <cfif isdefined('form.fLOCtipo') and form.fLOCtipo EQ 'V'> selected</cfif>>Valor por Pa&iacute;s</option>
						</select>
					</td>
					<td width="39%" align="center"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar"></td>
				  </tr>
				</table>
			</form>
		</td>
	  </tr>
	  <tr>
		<td>
			<cfinvoke component="aspAdmin.Componentes.pListasASP" 
					  method="pLista" 
					  returnvariable="pListaConceptos">
				<cfinvokeargument name="tabla" value="LocaleConcepto"/>
				<cfinvokeargument name="columnas" value="
					convert(varchar,LOCid) as LOCid
					, LOCnombre
					, case
						when LOCtipo='I' then 'Lista por Idiomas'
						when LOCtipo='P' then 'Lista por País'
						when LOCtipo='V' then 'Valor por País'
					end LOCtipo"/>
				<cfinvokeargument name="desplegar" value="LOCnombre,LOCtipo"/>
				<cfinvokeargument name="etiquetas" value="Concepto,Tipo"/>
				<cfinvokeargument name="formatos"  value=""/>
				<cfinvokeargument name="filtro" value="#filtro#"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N,N"/>
				<cfinvokeargument name="keys" value="LOCid"/>
				<cfinvokeargument name="irA" value="conceptos.cfm"/>
				<cfinvokeargument name="formName" value="form_listaConceptos"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="botones" value="Nuevo"/>						
			</cfinvoke>			
		</td>
	  </tr>
	</table>
</cfoutput>