<cfquery name="rsLista"  datasource="#session.dsn#">
	select  ER.ERDid, ER.ERDdesc, ER.ERDmodulo, ER.ERDcodigo
    	from EReportDinamic ER
     where ER.Ecodigo=#session.Ecodigo#
     and ER.ERDmodulo ='CG'
     Order by ER.ERDcodigo
</cfquery>
<cfquery name="rsAnexos" datasource="#session.DSN#">
	<!--- buscar los anexos usando el cubo de grupos --->
	select ag.GAid, ag.GAnombre, a.AnexoId, a.AnexoDes
			,coalesce(a.AnexoSaldoConvertido,0) as TipoSaldo
	  from Anexo a
		inner join AnexoGrupoCubo cubo
		   on cubo.GAhijo 	= a.GAid
		 
		inner join AnexoGrupo ag
		   on ag.GAid 		= a.GAid
		  and ag.CEcodigo 	= a.CEcodigo

	 where a.CEcodigo = #session.CEcodigo#
	  and exists (
				select 1
				  from AnexoPermisoDef pd, AnexoEm ae
				 where (pd.GAid = a.GAid or pd.AnexoId = a.AnexoId)
				   and pd.Usucodigo 	= #session.Usucodigo#
				   and pd.APcalc 	= 1
				   and ae.AnexoId 	= a.AnexoId
				   and ae.Ecodigo 	= #session.Ecodigo#
			)
	 order by ag.GAruta, a.AnexoDes
</cfquery>
<cfquery name="rsTipoSaldos" dbtype="query">
	select distinct TipoSaldo
	  from rsAnexos
</cfquery>
<cfquery name="monedas" datasource="#session.DSN#">
	select Mcodigo id, Mnombre as descripcion
	from Monedas
	where Ecodigo = #session.Ecodigo#
	order by Mnombre
</cfquery>
<cfquery name="mes" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #session.Ecodigo#
	and Pcodigo = 60
</cfquery>
<cfparam name="url.ACmes" default="#mes.Pvalor#">
<cfquery name="periodo" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #session.Ecodigo#
	and Pcodigo = 50
</cfquery>
<cfparam name="url.ACano" default="#periodo.Pvalor#">
<cfif isdefined("url.MODO")>
	<cfset MODO = URL.MODO>
</cfif>
<cfparam name="MODO" default="ALTA">

<table>
	<tr>
    	<td align="right" >
        	Reporte:
        </td>
    	<td>
        	<select id="ERDid" name="ERDid" >
	            <option value="">Seleccione el Reporte</option>
        	<cfloop query="rsLista" >
            	<cfoutput>
            	<option id="ERDid" value="#rsLista.ERDid#">#rsLista.ERDdesc#</option>
                </cfoutput>  
            </cfloop>
            </select>      	
        </td>
    </tr>
    <tr>
    	<td align="right" valign="top">Origen de Datos:&nbsp;</td>
		<td colspan="2" valign="top">
			<cfparam name="myEcodigo"	default="#session.Ecodigo#">
			<cfparam name="myGEid"		default="-1">
			<cfparam name="myGOid"		default="-1">
			<cfparam name="myOcodigo"	default="-1">
			<cfparam name="myGODid"		default="-1">
			<cfparam name="url.ANubicaTipo"	default="E">
			<cfparam name="url.ANubicaID"	default="-1">
			<cfif url.ANubicaTipo EQ "GE">
				<cfset myGEid 		= url.ANubicaID>
				<cfset myEcodigo	= -1>
			<cfelseif url.ANubicaTipo EQ "GO">
				<cfset myGOid		= url.ANubicaID>
			<cfelseif url.ANubicaTipo EQ "O">
				<cfset myOcodigo	= url.ANubicaID>
			<cfelseif url.ANubicaTipo EQ "GOD">
				<cfset myGODid	= url.ANubicaID>
				<cfset myEcodigo	= -1>
			</cfif>
			<cf_cboANubicacion
						Ecodigo	= "#myEcodigo#" 
						Ocodigo	= "#myOcodigo#" 
						GOid	= "#myGOid#" 
						GEid	= "#myGEid#" 
						GODid	= "#myGODid#" 
						modo	= "CAMBIO" 
						tipo	= "CALCULO"
			>
        </td>
    </tr>
    <tr>
		<td align="right" valign="top">Movs. en Moneda:&nbsp;</td>
		<td colspan="2" valign="top">
		<cfif rsTipoSaldos.recordCount EQ 1 AND rsAnexos.TipoSaldo EQ 2>
			<input type="hidden" name="Mcodigo" value="-1">
			<strong>El anexo es multi-monedas</strong>
		<cfelse>
			<select name="Mcodigo" style="width:250px" onChange="if(this.value==-1){this.form.ACmLocal.disabled=true;this.form.ACmLocal.checked=true;} else if (this.form.ACmLocal.disabled){this.form.ACmLocal.disabled=false;this.form.ACmLocal.checked=false;}">
				<option value="-1" >-Movimientos en cualquier moneda-</option>
				<cfoutput query="monedas">
					<option value="#monedas.id#" >#monedas.descripcion#</option>
				</cfoutput>
			</select><input type="checkbox" name="ACmLocal" value="1" checked disabled>Expresado en Local
		</cfif>
		</td>
	</tr>
    <tr>
      <td align="right" valign="top">Mes:&nbsp;</td>
      <td colspan="2" valign="top"><select name="ACmes" style="width:120px">
          <option value="" >-seleccionar-</option>
          <option value="1" <cfif url.ACmes eq 1>selected</cfif>>Enero</option>
          <option value="2" <cfif url.ACmes eq 2>selected</cfif>>Febrero</option>
          <option value="3" <cfif url.ACmes eq 3>selected</cfif>>Marzo</option>
          <option value="4" <cfif url.ACmes eq 4>selected</cfif>>Abril</option>
          <option value="5" <cfif url.ACmes eq 5>selected</cfif>>Mayo</option>
          <option value="6" <cfif url.ACmes eq 6>selected</cfif>>Junio</option>
          <option value="7" <cfif url.ACmes eq 7>selected</cfif>>Julio</option>
          <option value="8" <cfif url.ACmes eq 8>selected</cfif>>Agosto</option>
          <option value="9" <cfif url.ACmes eq 9>selected</cfif>>Setiembre</option>
          <option value="10" <cfif url.ACmes eq 10>selected</cfif>>Octubre</option>
          <option value="11" <cfif url.ACmes eq 11>selected</cfif>>Noviembre</option>
          <option value="12" <cfif url.ACmes eq 12>selected</cfif>>Diciembre</option>
        </select>
        <cfoutput>
          <input name="ACano" value="#url.ACano#" size="5" maxlength="5" style="text-align: right;width:75px" 
				onBlur="javascript:fm(this,0);" onFocus="javascript:this.value=qf(this); this.select();"  
				onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" >
        </cfoutput> </td>
    </tr>
    <tr>
      <td align="right" valign="top">Unidades:&nbsp;</td>
      <td colspan="2" valign="top"><select name="ACunidad" style="width:200px">
          <option value="1" >1</option>
          <option value="1000" >1,000</option>
          <option value="1000000" >1,000,000</option>
        </select>
      </td>
    </tr>
    <tr>
    	<td colspan="4" align="center">
        	<input type="submit" value="Generar" name="generar" id="generar"/>
        </td>
    </tr>
</table>




