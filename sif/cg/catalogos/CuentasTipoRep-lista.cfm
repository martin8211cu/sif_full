<!--- 
	Modificado por: Gustavo Fonseca H.
		Fecha: 10-3-2006.
		Motivo: Se corrige la navegaciÃ³n del form por tabs para que tenga un orden lÃ³gico.
 --->
<cfquery name="rsTiposRep" datasource="#Session.DSN#">
	select CGARepid, CGARepDes
	from CGAreasTipoRep
	where CGARepid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#fCGARepid#">
</cfquery>

<cfset filtro = "">

<cfif isdefined("Form.fCGARepid") and Len(Trim(Form.fCGARepid))>
	<cfset filtro = filtro & " and a.CGARepid = " & Form.fCGARepid>
</cfif>
<cfif isdefined("Form.fCmayor") and Len(Trim(Form.fCmayor))>
	<cfset filtro = filtro & " and a.CGARCtaMayor = '" & Form.fCmayor & "'">
</cfif>
<cfif isdefined("Form.fCtipo") and Len(Trim(Form.fCtipo))>
	<cfset filtro = filtro & " and a.CGARctaTipo = '" & Form.fCtipo & "'">
</cfif>
<cfif isdefined("Form.fCsubtipo") and Len(Trim(Form.fCsubtipo))>
	<cfset filtro = filtro & " and a.CGARctaGrupo = " & Form.fCsubtipo>
</cfif>
<cfif isdefined("Form.fCGARctaBalance") and Len(Trim(Form.fCGARctaBalance))>
	<cfset filtro = filtro & " and a.CGARctaBalance = " & Form.fCGARctaBalance>
</cfif>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td class="tituloAlterno" align="center" style="text-transform: uppercase; ">
			<strong>Lista de Cuentas por Tipo de Reporte</strong>
		</td>
      </tr>
	  <tr>
		<td>
			<cfset campos = "">
			<form name="filtro" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0;">
				<input type="hidden" name="fCGARepid" value="<cfif isdefined ("form.fCGARepid") and len(trim(form.fCGARepid))><cfoutput>#form.fCGARepid#</cfoutput></cfif>">
				<input name="tab" type="hidden" value="1">
				<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
				  <tr>
					<td nowrap style="background-color:##CCCCCC"><strong>Cta Mayor</strong></td>
					<td nowrap style="background-color:##CCCCCC"><strong>Tipo</strong></td>
					<td nowrap style="background-color:##CCCCCC"><strong>Subtipo</strong></td>
					<td nowrap style="background-color:##CCCCCC"><strong>Balance</strong></td>
					<td nowrap style="background-color:##CCCCCC">&nbsp;</td>
				  </tr>
				  <tr>
					<td>
						<input type="text" name="fCmayor" size="10" tabindex="2" maxlength="4" value="<cfif isdefined("Form.fCmayor")><cfset campos = campos & "'" & #Form.fCmayor# & "' as fCmayor,">#Form.fCmayor#</cfif>"/>
					</td>
					<td>
					  <select name="fCtipo" id="fCtipo" onChange="javascript: changeTipo(this);" tabindex="2">
						<option value="">Todos</option>
						<option value="A" <cfif isdefined("Form.fCtipo") and Form.fCtipo EQ "A"><cfset campos = campos & "'" & #Form.fCtipo# & "' as fCtipo,"> selected</cfif>>Activo</option>
						<option value="P" <cfif isdefined("Form.fCtipo") and Form.fCtipo EQ "P"><cfset campos = campos & "'" & #Form.fCtipo# & "' as fCtipo,"> selected</cfif>>Pasivo</option>
						<option value="C" <cfif isdefined("Form.fCtipo") and Form.fCtipo EQ "C"><cfset campos = campos & "'" & #Form.fCtipo# & "' as fCtipo,"> selected</cfif>>Capital</option>
						<option value="I" <cfif isdefined("Form.fCtipo") and Form.fCtipo EQ "I"><cfset campos = campos & "'" & #Form.fCtipo# & "' as fCtipo,"> selected</cfif>>Ingreso</option>
						<option value="G" <cfif isdefined("Form.fCtipo") and Form.fCtipo EQ "G"><cfset campos = campos & "'" & #Form.fCtipo# & "' as fCtipo,"> selected</cfif>>Gasto</option>
						<option value="O" <cfif isdefined("Form.fCtipo") and Form.fCtipo EQ "O"><cfset campos = campos & "'" & #Form.fCtipo# & "' as fCtipo,"> selected</cfif>>Orden</option>
					  </select>
					</td>
					<td>
					  <select name="fCsubtipo" id="fCsubtipo" tabindex="2">
						<option value="">Todos</option>
						<option value="1" <cfif isdefined("Form.fCsubtipo") and Form.fCsubtipo EQ "1"><cfset campos = campos & #Form.fCsubtipo# & " as fCsubtipo,"> selected</cfif>>Ventas o Ingresos</option>
						<option value="2" <cfif isdefined("Form.fCsubtipo") and Form.fCsubtipo EQ "2"><cfset campos = campos & #Form.fCsubtipo# & " as fCsubtipo,"> selected</cfif>>Costos de Operaci&oacute;n</option>
						<option value="3" <cfif isdefined("Form.fCsubtipo") and Form.fCsubtipo EQ "3"><cfset campos = campos & #Form.fCsubtipo# & " as fCsubtipo,"> selected</cfif>>Gastos de Operaci&oacute;n y Administrativos</option>
						<option value="4" <cfif isdefined("Form.fCsubtipo") and Form.fCsubtipo EQ "4"><cfset campos = campos & #Form.fCsubtipo# & " as fCsubtipo,"> selected</cfif>>Otros Ingresos Gravables</option>
						<option value="5" <cfif isdefined("Form.fCsubtipo") and Form.fCsubtipo EQ "5"><cfset campos = campos & #Form.fCsubtipo# & " as fCsubtipo,"> selected</cfif>>Otros Gastos Deducibles</option>
						<option value="6" <cfif isdefined("Form.fCsubtipo") and Form.fCsubtipo EQ "6"><cfset campos = campos & #Form.fCsubtipo# & " as fCsubtipo,"> selected</cfif>>Ingresos no Gravables</option>
						<option value="7" <cfif isdefined("Form.fCsubtipo") and Form.fCsubtipo EQ "7"><cfset campos = campos & #Form.fCsubtipo# & " as fCsubtipo,"> selected</cfif>>Gastos no Deducibles</option>
						<option value="8" <cfif isdefined("Form.fCsubtipo") and Form.fCsubtipo EQ "8"><cfset campos = campos & #Form.fCsubtipo# & " as fCsubtipo,"> selected</cfif>>Impuestos</option>
					  </select>
					</td>
					<td>
						<select name="fCGARctaBalance" tabindex="2">
							<option value="">Todos</option>
							<option value="1" <cfif isdefined("Form.fCGARctaBalance") and Form.fCGARctaBalance EQ "1"><cfset campos = campos & #Form.fCGARctaBalance# & " as fCGARctaBalance,"> selected</cfif>>D&eacute;bito</option>
							<option value="-1" <cfif isdefined("Form.fCGARctaBalance") and Form.fCGARctaBalance EQ "-1"><cfset campos = campos & #Form.fCGARctaBalance# & " as fCGARctaBalance,"> selected</cfif>>Cr&eacute;dito</option>
						</select>
					</td>
					<td>
						<input type="submit" name="btnFiltrar" value="Filtrar" tabindex="2">
					</td>
				  </tr>
				</table>
			</form>
		</td>
	  </tr>
	  <tr>
		<td valign="top">
			
			<cfif len(campos) gt 0>
				<cfif mid(trim(campos),len(trim(campos)),1) eq "," >
					<cfset campos = "," & mid(trim(campos),1,(len(trim(campos))-1)) & " ">
				<cfelse>
					<cfset campos = "," & campos & " ">
				</cfif>
			</cfif>
			
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pLista"
				returnvariable="pListaRet"
				columnas="	a.CGARepid,   
							a.CGARCtaMayor, 
							case 
							when a.CGARctaTipo = 'A' then 'Activo' 
							when a.CGARctaTipo = 'P' then 'Pasivo' 
							when a.CGARctaTipo = 'C' then 'Capital'
							when a.CGARctaTipo = 'I' then 'Ingreso' 
							when a.CGARctaTipo = 'G' then 'Gasto' 
							when a.CGARctaTipo = 'O' then 'Orden'  
							else ''
							end as Tipo,
							case 
							when a.CGARctaGrupo = 1 then 'Ventas o Ingresos' 
							when a.CGARctaGrupo = 2 then 'Costos de Operaci&oacute;n' 
							when a.CGARctaGrupo = 3 then 'Gastos de Operaci&oacute;n y Administrativos'
							when a.CGARctaGrupo = 4 then 'Otros Ingresos Gravables' 
							when a.CGARctaGrupo = 5 then 'Otros Gastos Deducibles' 
							when a.CGARctaGrupo = 6 then 'Ingresos no Gravables'  
							when a.CGARctaGrupo = 7 then 'Gastos no Deducibles'  
							when a.CGARctaGrupo = 8 then 'Impuestos'  
							else ''
							end as Subtipo,
							case when a.CGARctaBalance = 1 then 'D&eacute;bito' else 'Cr&eacute;dito' end as Balance #campos#"
				tabla="CGAreasTipoRepCtas a
						inner join CGAreasTipoRep b
							on b.CGARepid = a.CGARepid "
				filtro="1=1 #PreserveSingleQuotes(filtro)# order by a.CGARCtaMayor, a.CGARctaTipo, a.CGARctaGrupo, a.CGARctaBalance"
				desplegar="CGARCtaMayor, Tipo, Subtipo, Balance"
				etiquetas="Cuenta Mayor, Tipo, Subtipo, Balance"
				formatos="S,S,S,S"
				align="left, left, left, left"
				checkboxes="N"
				ira="CuentasTipoRep_Option.cfm"
				nuevo="CuentasTipoRep_Option.cfm"
				showLink="true"
				showemptylistmsg="true"
				keys="CGARepid, CGARCtaMayor"
				mostrar_filtro="false"
				filtrar_automatico="true"
				maxrows="15"
				navegacion="#navegacion#"
				/>
			
		</td>
	  </tr>
	  <tr>
	    <td>&nbsp;</td>
      </tr>
	</table>
</cfoutput>

