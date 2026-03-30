<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td>
			<cfinclude template="ordenCompra-filtroglobal.cfm">
			<cfset navegacion = "">
			<cfif isdefined("form.fEOnumero") and len(trim(form.fEOnumero)) >
				<cfset navegacion = navegacion & "&fEOnumero=#form.fEOnumero#">
			</cfif>
			<cfif isdefined("form.fEOnumero2") and len(trim(form.fEOnumero2)) >
				<cfset navegacion = navegacion & "&fEOnumero2=#form.fEOnumero2#">
			</cfif>
			<cfif isdefined("form.fObservaciones") and len(trim(form.fObservaciones)) >
				<cfset navegacion = navegacion & "&fObservaciones=#form.fObservaciones#">
			</cfif>
			<cfif isdefined("Form.fEOfecha") and len(trim(form.fEOfecha))>
				<cfset navegacion = navegacion & "&fEOfecha=#form.fEOfecha#">
			</cfif>
			<cfif isdefined("Form.SNcodigoF") and len(trim(Form.SNcodigoF)) >
				<cfset navegacion = navegacion & "&SNcodigoF=#form.SNcodigoF#">
			</cfif>
            
            <cfinclude template="../../Utiles/sifConcat.cfm">
			<cfquery name="rsLista" datasource="#session.DSN#">
					select 
						a.EOidorden, a.EOnumero, a.SNcodigo, 
						a.CMCid, a.Mcodigo, a.Rcodigo, a.CMTOcodigo, 
						a.EOfecha, a.Observaciones, a.EOtc, a.EOrefcot, 
						a.Impuesto, a.EOdesc, a.EOtotal, a.Usucodigo, 
						a.EOfalta, a.Usucodigomod, a.fechamod, a.EOplazo, 
						a.NAP, a.NRP, a.NAPcancel, a.EOporcanticipo, a.EOestado, 
						b.Mnombre, c.CMCnombre, d.Rdescripcion, e.SNnombre, 
						f.CMTOcodigo#_Cat#'-'#_Cat#f.CMTOdescripcion as descripcion
					from EOrdenCM a
						left outer join Monedas b on a.Ecodigo = b.Ecodigo and a.Mcodigo = b.Mcodigo
						left outer join CMCompradores c on a.Ecodigo = c.Ecodigo and a.CMCid = c.CMCid
						left outer join Retenciones d on a.Ecodigo = d.Ecodigo and a.Rcodigo = d.Rcodigo
						left outer join SNegocios e on a.Ecodigo = e.Ecodigo and a.SNcodigo = e.SNcodigo
						left outer join CMTipoOrden f on a.Ecodigo =f.Ecodigo and a.CMTOcodigo = f.CMTOcodigo
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and a.CMCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.compras.comprador#">
						and a.EOestado in (-8,0,5,7,8,9)

				<cfif isdefined("form.fEOnumero") and len(trim(form.fEOnumero)) and isdefined("form.fEOnumero2") and len(trim(form.fEOnumero2))>
					and a.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fEOnumero#"> and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fEOnumero2#">
				<cfelseif isdefined("form.fEOnumero") and len(trim(form.fEOnumero))>
					and a.EOnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fEOnumero#">
				<cfelseif isdefined("form.fEOnumero2") and len(trim(form.fEOnumero2))>
					and a.EOnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fEOnumero2#">
				</cfif>

				<cfif isdefined("form.fObservaciones") and len(trim(form.fObservaciones)) >
					and upper(Observaciones) like  upper('%#form.fObservaciones#%')
				</cfif>

				<cfif isdefined("Form.SNcodigoF") and len(trim(Form.SNcodigoF)) >
					and e.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigoF#">
				</cfif>

				<cfif isdefined("Form.fEOfecha") and len(trim(Form.fEOfecha)) >
					<cfset fin = dateadd('d', 1, LSParsedatetime(form.fEOfecha)) >
					<cfset fin = dateadd('l', -1, fin) >
					and EOfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fEOfecha)#"> 
					                and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fin#">
				</cfif>
				order by descripcion,EOnumero
			</cfquery>
          <!---  <form name="lista" action="anulacionOrdenCompra-sql.cfm" method="post">
            <cfif lvarProvCorp>
            	<input name="Ecodigo_f" type="hidden" value="<cfoutput>#form.Ecodigo_f#</cfoutput>" />
           	</cfif>--->
			<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="cortes" value="descripcion"/>
				<cfinvokeargument name="desplegar" value="EOnumero, Observaciones, SNnombre, EOfecha, Mnombre, EOtotal"/>
				<cfinvokeargument name="etiquetas" value="N&uacute;mero, Descripci&oacute;n, Proveedor, Fecha, Moneda, Total"/>
				<cfinvokeargument name="formatos" value="V,V,V,D,V,M"/>
				<cfinvokeargument name="align" value="left,left,left,center,left,right"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="anulaOrden.cfm"/>
				<cfinvokeargument name="botones" value="Anular"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="EOidorden"/>
				<!----<cfinvokeargument name="showLink" value="false"/>---->
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="radios" value="S"/>
				<!---<cfinvokeargument name="incluyeForm" value="false"/>--->
			</cfinvoke>
<!---            </form>--->
		</td>
	</tr>
</table>

<script language="javascript1.2" type="text/javascript">
	function funcAnular(){
		var continuar = false;
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				continuar = true;
			}
			else {
				for (var k = 0; k < document.lista.chk.length; k++) {
					if (document.lista.chk[k].checked) {
						continuar = true;
						break;
					}
				}
			}
			if (!continuar) { alert('Debe seleccionar una Orden de Compra de la lista'); }
		}
		else {
			alert('No existen Ordenes de compra aplicadas')
		}

		if ( continuar ){
			document.lista.action = 'anulacionOrdenCompra-sql.cfm';
			document.lista.submit();
		}	

		return continuar;
	}
</script>