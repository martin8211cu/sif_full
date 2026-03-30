<!--- 
	Creado por Gustavo Fonseca H.
	Fecha: 5-1-2007.
	Motivo: Soporte del proceso de Cierre Anual.
 --->

<cfquery datasource="#Session.DSN#" name="rsNivelDef">
	select ltrim(rtrim(Pvalor)) as valor
	from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	and Pcodigo = 10 
</cfquery>

<cfset nivelDef="#ArrayLen(ListtoArray(rsNivelDef.valor, '-'))#">
<cfset lvarMaximoNiveles = 6>

<cfquery name="rsNivelMascara" datasource="#Session.DSN#">
	select max(n.PCNid) as MaximoNiveles
	from CtasMayor m
		inner join PCNivelMascara n
		on n.PCEMid = m.PCEMid
	where m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
</cfquery>

<cfif isdefined('rsNivelMascara') and rsNivelMascara.MaximoNiveles GT 0>
	<cfset lvarMaximoNiveles = rsNivelMascara.MaximoNiveles>
</cfif>

<cfoutput>
	<form name="form1" method="post" action="AsientoLiquidacionCierreAnual.cfm" style="MARGIN:0;">
		<table cellpadding="0" cellspacing="0" border="0" style="width:100%">
			<tr>
				<td align="right" colspan="2" nowrap>&nbsp;</td>
			</tr>
			<tr>
				<td align="right" style="width:45%"><strong>Cuenta Contable Mayor:&nbsp;</strong></td>

				<td nowrap align="left">
					<cf_sifCuentasMayor form="form1" Cmayor="cmayor_ccuenta1" Cdescripcion="Cdescripcion1" size="50" tabindex="1">
				</td>	
			</tr>
			<tr>
				<td align="right"><strong>Nivel:&nbsp;</strong></td>
				<td align="left">	
					<select name="nivel" size="1" id="nivel" tabindex="1">
                    <cfloop index="i" from="0" to="#lvarMaximoNiveles#">
                      <option value="<cfoutput>#i#</cfoutput>"
						  	<cfif nivelDef EQ i>selected</cfif>> <cfoutput>#i#</cfoutput> </option>
                    </cfloop>
                  </select>
				</td>	
			</tr>
			<tr>
				<td align="right"><strong>Oficina:&nbsp;</strong></td>
				<td colspan="3">								
					<cfset ArrayOF=ArrayNew(1)>
					<cf_conlis
						Campos="Ocodigo,Oficodigo,Odescripcion"
						Desplegables="N,S,S"
						Modificables="N,S,N"
						Size="0,10,40"
						ValuesArray="#ArrayOF#" 
						Title="Lista de Oficinas"
						Tabla="Oficinas"
						Columnas="Ocodigo,Oficodigo,Odescripcion"
						Filtro="Ecodigo = #Session.Ecodigo#"
						Desplegar="Oficodigo,Odescripcion"
						Etiquetas="C&oacute;digo,Descripci&oacute;n"
						filtrar_por="Oficodigo,Odescripcion"
						Formatos="S,S"
						tabindex="1"
						Align="left,left"
						Asignar="Ocodigo,Oficodigo,Odescripcion"
						Asignarformatos="S,S,S"/>
				</td>	
			</tr>

			<tr>  
				<td align="center" colspan="2">
					<input type="hidden" name="Eperiodo" value="#form.Eperiodo#">
					<input type="hidden" name="Emes" 	value="#form.Emes#">
					<input type="hidden" name="Cconcepto" 	value="#form.Cconcepto#">
					
                    <cfif not isdefined("form.btnProcesar")>
                    	<input type="submit" name="btnProcesar" value="Procesar" tabindex="1">
                    </cfif>
					
                    <input type="submit" name="btnRegresar" value="Regresar" tabindex="1" onclick="document.form1.action='DocumentosContablesCierreAnual.cfm?inter=N&modo=ALTA'">
                    
				</td>
			</tr> 
		</table>
	</form>
</cfoutput>

<cfif isdefined("form.btnProcesar")>
	
	<cfif isdefined("form.Ocodigo") and Len(trim(form.Ocodigo)) and form.Ocodigo GTE 0>
		<cfinvoke 
			component="sif.Componentes.CG_CierreAnual" 
				method="AsientoLiquida"
				  CMayor="#form.cmayor_ccuenta1#"
				  Ecodigo="#session.Ecodigo#"
				  NivelParametro="#form.Nivel#"
				  Periodo="#form.EPeriodo#"
				  Mes="#form.EMes#"
				  Ocodigo="#form.Ocodigo#"
				  Cconcepto="#form.Cconcepto#"
				  debug="false"/>
	<cfelse>
		<cfinvoke 
			component="sif.Componentes.CG_CierreAnual" 
				method="AsientoLiquida"
				  CMayor="#form.cmayor_ccuenta1#"
				  Ecodigo="#session.Ecodigo#"
				  NivelParametro="#form.Nivel#"
				  Periodo="#form.EPeriodo#"
				  Mes="#form.EMes#"
				  Cconcepto="#form.Cconcepto#"
				  debug="false"/>
	</cfif>
	
    <form name="form2" method="post" action="">
	    <input type="submit" name="btnRegresar" value="Regresar" tabindex="1" onclick="document.form2.action='DocumentosContablesCierreAnual.cfm?inter=N&modo=ALTA'">	
    </form>
	
    <cflocation url="listaDocumentosContablesCierreAnual.cfm" addtoken="no">
</cfif>
