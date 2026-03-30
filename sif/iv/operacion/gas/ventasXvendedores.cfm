<html>
<head>
<title>Ventas de Vendedores</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<style type="text/css">
<!--
.style1 {
	font-size: 18px;
	font-weight: bold;
}
.style2 {
	font-size: 14px;
	font-weight: bold;
}
-->
</style>
</head>
<body>

<cfoutput>
	<cfif isdefined("url.ID_dsalprod") and not isdefined('form.ID_dsalprod')>
		<cfset form.ID_dsalprod = url.ID_dsalprod>
	</cfif>		
	<cfset nombreProd = "">	
	<cfset listaCods = "">	
	<cfset LvarListaNon = -1>
	<cfinclude template="../../../Utiles/sifConcat.cfm">	
	<cfquery name="rsVendedores" datasource="#session.DSN#">
		select v.ESVid
			, coalesce(dds.DDScantidad,0) as DDScantidad
			, (v.ESVnombre #_Cat# ' ' #_Cat# v.ESVapellido1 #_Cat# '' #_Cat# v.ESVapellido2) as nombre
			, v.ESVcodigo
			, dds.DDSPlinea
			, dds.ID_dsalprod
			, ar.Aid
			, ar.Acodigo
			, ar.Adescripcion
			, (ds.Unidades_vendidas + ds.Unidades_despachadas) as totSal
		from ESVendedores v
			left outer join DDSalidaProd dds
				on dds.Ecodigo=v.Ecodigo
					and dds.ESVid=v.ESVid
					and dds.ID_dsalprod=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_dsalprod#">
		
			left outer join DSalidaProd ds
				on ds.Ecodigo=dds.Ecodigo
					and ds.ID_dsalprod=dds.ID_dsalprod
					
			left outer join ESalidaProd es
				on es.Ecodigo=ds.Ecodigo
					and es.ID_salprod=ds.ID_salprod
		
			left outer join Oficinas o
				on o.Ecodigo=es.Ecodigo
					and o.Ocodigo=es.Ocodigo
					and o.Ocodigo=v.Ocodigo					
		
			left outer join Articulos ar
				on ar.Ecodigo=ds.Ecodigo
					and ar.Aid=ds.Aid
		
		where v.Ecodigo= #session.Ecodigo# 
	</cfquery>	
	<cfset totSal = 0>
	<cfset estado = 0>	
	
	<cfif isdefined('rsVendedores') and rsVendedores.recordCount GT 0>
		<cfquery name="rsArticulo" datasource="#session.DSN#">
			select a.Aid, b.Acodigo, b.Adescripcion, c.Cdescripcion, en.SPestado
			from DSalidaProd a
				inner join ESalidaProd en
					on en.Ecodigo=a.Ecodigo
						and en.ID_salprod=a.ID_salprod
						
				inner join Articulos b
					on b.Ecodigo=a.Ecodigo
						and b.Aid=a.Aid
			
				inner join Clasificaciones c
					on c.Ecodigo=b.Ecodigo
						and c.Ccodigo=b.Ccodigo
			
			where a.ID_dsalprod=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_dsalprod#">
		</cfquery>

		<cfquery name="rsTotSalidaProd" dbtype="query" maxrows="1">
			Select totSal
			from rsVendedores
			where totSal > 0
		</cfquery>	

		<cfif isdefined('rsTotSalidaProd') and rsTotSalidaProd.recordCount GT 0 and rsTotSalidaProd.totSal GT 0>
			<cfset totSal = rsTotSalidaProd.totSal>
		<cfelse>
			<cfquery name="rsTotSalidaProd" datasource="#session.DSN#">
				select (Unidades_vendidas + Unidades_despachadas) as totSal
					, Unidades_vendidas 
					, Unidades_despachadas 
				from DSalidaProd
				where Ecodigo= #session.Ecodigo# 
					and ID_dsalprod= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_dsalprod#">
			</cfquery>		
			<cfif isdefined('rsTotSalidaProd') and rsTotSalidaProd.recordCount GT 0 and rsTotSalidaProd.totSal GT 0>
				<cfset totSal = rsTotSalidaProd.totSal>
			</cfif>
		</cfif>
		
		<cfset nombreProd = rsArticulo.Cdescripcion & ': (' & rsArticulo.Acodigo & ') ' & rsArticulo.Adescripcion>
		<cfset estado = rsArticulo.SPestado>			
		<cfset listaCods = ValueList(rsVendedores.ESVid)>			
		
		<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js">//</script>
		<form style="margin:0;" name="frame_Vend" method="post" action="ventasXvendedores.cfm" onSubmit="javascript: return valida(this);">
			<input type="hidden" name="totSalida" value="#totSal#">
			<input type="hidden" name="ID_dsalprod" value="<cfif isdefined('form.ID_dsalprod') and form.ID_dsalprod NEQ ''>#form.ID_dsalprod#</cfif>">		
			<input type="hidden" name="listaCods" value="<cfif isdefined('listaCods') and listaCods NEQ ''>#listaCods#</cfif>">
			
		  <table width="100%" cellpadding="0" cellspacing="0" border="0">  
			<tr>
			  <td colspan="5" align="center">&nbsp;</td>
			</tr>		
			<tr>
			  <td colspan="5" align="center">&nbsp;</td>
			</tr>		
			<tr>
			  <td colspan="5" align="center"><span class="style1">Unidades Vendidas o Despachadas por Vendedor</span></td>
			</tr>	
			<tr>
			  <td colspan="5" align="center">&nbsp;</td>
			</tr>		
			<tr>
			  <td colspan="5" align="center">
			  	<span class="style2">
			  		#nombreProd#
				</span> 
			  </td>
			</tr>
			<tr>
			  <td colspan="5" align="center">&nbsp;</td>
			</tr>		
			<tr>
			  <td colspan="5" align="center"><hr></td>
			</tr>				  
			<tr>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			</tr>		
			<tr class="areaFiltro">
			  <td width="10%" align="center">&nbsp;</td>
			  <td width="24%" align="center" nowrap="nowrap"><strong>Nombre del Vendedor</strong></td>
			  <td width="2%">&nbsp;</td>
			  <td width="53%" align="right"><strong>Cantidad de Unidades del Producto </strong></td>
			  <td width="11%" align="center">&nbsp;</td>
			</tr>
			<tr>
			  <td colspan="5" align="center">&nbsp;</td>
			</tr>			
			<cfif isdefined('rsVendedores') and rsVendedores.recordCount GT 0>
				<cfloop query="rsVendedores">
					<cfset LvarListaNon = (CurrentRow MOD 2)>	
					
					<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onMouseOver="this.className='listaParSel';" onMouseOut="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
					  <td align="right">#ESVcodigo#&nbsp;-&nbsp;</td>
					  <td>#nombre#</td>
					  <td>&nbsp;</td>
					  <td align="right"><input 
								type="text" 
								tabindex="-1"
								name="cant_#ESVid#" 
								size="10" 
								maxlength="10" 
								style="text-align: right;" 
								onBlur="javascript:fm(this,2);"  
								onFocus="javascript:this.value=qf(this); this.select();"  
								onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}calcTotal();}"
								value="#LSCurrencyFormat(DDScantidad, 'none')#"></td>
					  <td align="center">&nbsp;</td>
					</tr>
				</cfloop>
			</cfif>
			<tr>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			</tr>
			<tr>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			</tr>			
			<tr>
			  <td>&nbsp;</td>
			  <td align="right"><strong>Total</strong></td>
			  <td>&nbsp;</td>
			  <td align="right"><strong><input 
						type="text" 
						class="cajasinbordeb"
						readonly="true" tabindex="-1"
						name="total" 
						size="20" 
						maxlength="20" 
						style="text-align: right;" 
						onBlur="javascript:fm(this,2);"  
						onFocus="javascript:this.value=qf(this); this.select();"  
						onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
						value=""></strong></td>
			  <td align="center">&nbsp;</td>
			</tr>
			<tr>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			</tr>						
			<tr>
			  <td colspan="5" align="center">
			  	<cfif estado NEQ 10>
					<input type="submit" name="btnGuardar" value="Guardar y Cerrar">
				<cfelse>
					<input type="button" onClick="javascript: cerrar();" name="Cerrar" value="Cerrar">
				</cfif>
			  </td>
			</tr>		
		  </table>
		</form>	
		
	<cfelse>
		<table width="100%" border="0">
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td align="center"><strong>---		No existen datos de vendedores para este articulo		---</strong></td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>		  		  
		  <tr>
			<td>&nbsp;</td>
		  </tr>		  		  
		  <tr>
			<td align="center">
			    <input type="button" onClick="javascript: cerrar();" name="Cerrar" value="Cerrar">
			</td>
		  </tr>		  
		</table>
	</cfif>

	<cfif isdefined('form.btnGuardar') and isdefined('rsVendedores') and rsVendedores.recordCount GT 0>
		<!--- Actualizando los datos de las ventas por vendedor --->
		<cfif isdefined("rsVendedores") and rsVendedores.recordCount GT 0>
			<cfloop query="rsVendedores">
				<cfset valor = evaluate("form.cant_#rsVendedores.ESVid#")>				

				<cfif rsVendedores.DDSPlinea NEQ ''>
					<cfquery datasource="#session.DSN#">
						update DDSalidaProd set
							DDScantidad=<cfqueryparam cfsqltype="cf_sql_float" value="#valor#">
						where DDSPlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVendedores.DDSPlinea#">						
					</cfquery>							
				<cfelse>
					<cfif valor GT 0>
						<cfquery datasource="#session.DSN#"> 				
							insert into DDSalidaProd 
								(Ecodigo, ID_dsalprod, ESVid, Aid, DDScantidad, BMUsucodigo, BMfechaalta)
							values (
								  #session.Ecodigo# 
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_dsalprod#">
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVendedores.ESVid#">
								, <cfqueryparam cfsqltype="cf_sql_float"   value="#rsArticulo.Aid#">
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#valor#">
								,  #session.Usucodigo# 
								, <cf_dbfunction name="now">)
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>			
		</cfif>
	</cfif>
</cfoutput>

</body>
</html>

<script language="javascript" type="text/javascript">
	function valida(f){
		var ret = true;
		var sumaObjst = 0;
		var totSalida = 0;
		var totSalVend = 3;				
		var objts = "<cfoutput>#listaCods#</cfoutput>";
		
		if (objts != ''){
			var arrObjts = objts.split(",");
			
			for (var i=0; i < arrObjts.length; i++){
				if(arrObjts[i] != ''){
					eval("f.cant_" + arrObjts[i] + ".value=qf(f.cant_" + arrObjts[i] + ")");								
					sumaObjst += eval("new Number(f.cant_" + arrObjts[i] + ".value)");
				}
			}
			totSalVend = new Number(sumaObjst);			
		}
		
		totSalida = new Number(f.totSalida.value);
		if((totSalida > totSalVend) || (totSalida < totSalVend)){
			alert("  Error, el total de salidas (" + totSalida + ")\nes distinto al total de unidades vendidas o despachadas\npor los vendedores (" + totSalVend + ")");
			ret = false;
		}
		formatea();
		return ret;
	}
	function cerrar(){
		window.close();
	}
	<cfif isdefined('form.btnGuardar')>
		cerrar();	
	</cfif>
	
	function formatea(){
		var objts = "<cfoutput>#listaCods#</cfoutput>";
		
		if (objts != ''){
			var arrObjts = objts.split(",");
			
			for (var i=0; i < arrObjts.length; i++){
				if(arrObjts[i] != ''){
					eval("document.frame_Vend.cant_" + arrObjts[i] + ".value=qf(document.frame_Vend.cant_" + arrObjts[i] + ")");
				}
			}	
		}	
	}
	
	function calcTotal(){
		var sumaObjst = 0;
		var totSalVend = 0;				
		var objts = "<cfoutput>#listaCods#</cfoutput>";
		
		if (objts != ''){
			var arrObjts = objts.split(",");
			
			for (var i=0; i < arrObjts.length; i++){
				if(arrObjts[i] != ''){
					eval("document.frame_Vend.cant_" + arrObjts[i] + ".value=qf(document.frame_Vend.cant_" + arrObjts[i] + ")");
					sumaObjst += eval("new Number(document.frame_Vend.cant_" + arrObjts[i] + ".value)");
				}
			}
			totSalVend = new Number(sumaObjst);			
		}
			
		document.frame_Vend.total.value = totSalVend;
	}
	calcTotal();
</script>
