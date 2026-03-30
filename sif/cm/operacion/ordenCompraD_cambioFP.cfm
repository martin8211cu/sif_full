<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfif isdefined("url.DOlinea") and len(trim(url.DOlinea))><cfset form.DOlinea = url.DOlinea></cfif>
<cfparam name="mododet" default="ALTA">
<cfif isdefined("form.DOlinea") and len(trim(form.DOlinea))><cfset mododet = "CAMBIO"></cfif>
<!--- Consultas --->
<cfif (modoDet EQ "CAMBIO")>
	<!--- Detalle de la Línea --->
	<cfquery name="rsLinea" datasource="#Session.DSN#">
		select eo.EOestado,a.DOlinea,a.Ecodigo,a.EOidorden,a.EOnumero,a.DOconsecutivo,
			a.ESidsolicitud,a.DSlinea,a.CMtipo,a.Cid,a.Aid,a.Alm_Aid,a.ACcodigo,
			a.ACid,a.CFid,a.Icodigo,a.Ucodigo,a.DOdescripcion,a.DOalterna,
			a.DOobservaciones,a.DOcantidad,a.DOcantsurtida,
			#LvarOBJ_PrecioU.enSQL_AS("a.DOpreciou")#,
			a.DOtotal,a.DOfechaes,a.DOgarantia,a.ts_rversion <!---Campos del Encabezado--->
			,f.Acodigo,f.Adescripcion 						 <!---Campos de Artículos--->
			,g.Ccodigo,g.Cdescripcion 						 <!---Campos de Conceptos--->
			,c.CFcodigo,c.CFdescripcion 					 <!---Campos de CentroFuncional--->
			,a.DOfechareq, a.Ppais,
			DOmontodesc, DOporcdesc
		from DOrdenCM a
			left outer join EOrdenCM eo
				on eo.Ecodigo = a.Ecodigo and eo.EOidorden = a.EOidorden
			left outer join Impuestos b
				on b.Ecodigo = a.Ecodigo and b.Icodigo = a.Icodigo
			left outer join CFuncional c
				on c.Ecodigo = a.Ecodigo and c.CFid = a.CFid
			left outer join Unidades d
				on d.Ecodigo = a.Ecodigo and d.Ucodigo = a.Ucodigo
			left outer join Almacen e
				on e.Ecodigo = a.Ecodigo and e.Aid = a.Alm_Aid
			left outer join Articulos f
				on f.Ecodigo = a.Ecodigo and f.Aid = a.Aid
			left outer join Conceptos g
				on g.Ecodigo = a.Ecodigo and g.Cid = a.Cid
		where a.Ecodigo = #session.Ecodigo#
		  and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		  and a.DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DOlinea#">
	</cfquery>

	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" 
		artimestamp="#rsLinea.ts_rversion#" 
		returnvariable="tsD">
	</cfinvoke>
</cfif>
<!--- Items permitidos coprar al comprador, si no hay ninguno marcado implica que no hay ninguna restricción, por tantose dará permiso para todo--->
<cfquery name="rsItems" datasource="#Session.DSN#">
	select CMTStarticulo, CMTSservicio, CMTSactivofijo 
	from CMCompradores 
	where Ecodigo = #session.Ecodigo#
	and CMCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.compras.comprador#">
</cfquery>
<cfif rsItems.RecordCount eq 0>
	<cf_errorCode	code = "50294" msg = " El Usuario Actual no está definido como comprador!, Acceso Denegado!">
<cfelseif rsItems.CMTStarticulo neq 1 and rsItems.CMTSservicio neq 1 and rsItems.CMTSactivofijo neq 1>
	<cfset allowAllItems = true>
<cfelse>
	<cfset allowAllItems = false>
</cfif>

<!---Permite modificar las ordenes de compra cuando vienen del registro de solicitudes--->
<cfquery name="rsModificaOC" datasource="#Session.DSN#">
    select Pvalor as value
    from Parametros
    where Ecodigo = #Session.Ecodigo#  
      and Pcodigo = 4310
</cfquery>

<!--- Almacenes --->
<cfquery name="rsAlmacenes" datasource="#Session.DSN#">
	select Aid, Bdescripcion 
	from Almacen 
	where Ecodigo = #session.Ecodigo#
	order by Bdescripcion                                                                   
</cfquery>
<!--- Categorias --->
<cfquery name="rsCategorias" datasource="#session.DSN#" >
	select ACcodigo, ACdescripcion 
	from ACategoria 
	where Ecodigo = #session.Ecodigo#
		<cfif (modoDet EQ "CAMBIO") and rsLinea.ACcodigo NEQ ''>
			and ACcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsLinea.ACcodigo#">
		<cfelse>
			Order by ACdescripcion
		</cfif>
</cfquery>
<!--- Clasificacion --->
<cfquery name="rsClasificacion" datasource="#Session.DSN#">
	select ACid, ACdescripcion, ACcodigo
	from AClasificacion 
	where Ecodigo = #session.Ecodigo#
	order by ACcodigo, ACdescripcion	
</cfquery>
<!---Impuetos--->
<cfquery name="rsImpuestos" datasource="#Session.DSN#">
	select Icodigo, Idescripcion 
	from Impuestos 
	where Ecodigo = #session.Ecodigo#
		<cfif (modoDet EQ "CAMBIO")>
			and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsLinea.Icodigo#">
		<cfelse>
			order by Idescripcion 
		</cfif>
</cfquery>
<!---Unidades--->
<cfquery name="rsUnidades" datasource="#session.DSN#">
	select Ucodigo, Udescripcion, Utipo
	from Unidades 
	where Ecodigo=#session.Ecodigo#
</cfquery>

<!---Pais del socio--->
<cfquery name="rsPaisSocio" datasource="#session.DSN#">
	select Ppais
	from SNegocios
	where Ecodigo=#session.Ecodigo#
	and SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOrden.SNcodigo#">
</cfquery>

<!---paises--->
<cfquery name="rsPais" datasource="asp">
	select Ppais, Pnombre
	from Pais 
		<cfif (modoDet EQ "CAMBIO") and rsLinea.Ppais NEQ ''>
			where Ppais=<cfqueryparam cfsqltype="cf_sql_char" value="#rsLinea.Ppais#">
		<cfelseif isdefined('rsPaisSocio') and rsPaisSocio.Ppais NEQ ''>
			where Ppais=<cfqueryparam cfsqltype="cf_sql_char" value="#rsPaisSocio.Ppais#">
		<cfelse>
			order by Pnombre
		</cfif>
</cfquery>

<!---JavaScript--->
<script language="javascript" type="text/javascript">
<!--// //poner a código javascript 
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlisCFuncional() {
		var params ="";
		params = "?CMCid=<cfoutput>#session.compras.comprador#</cfoutput>&form=form1&id=CFid&name=CFcodigo&desc=CFdescripcion";
		popUpWindow("/cfmx/sif/cm/operacion/ConlisCFuncional.cfm"+params,250,200,650,400);
	}

	//Obtiene la descripción con base al código
	function TraeCFuncional(dato) {
		var params ="";
		params = "&CMCid=<cfoutput>#session.compras.comprador#</cfoutput>&id=CFid&name=CFcodigo&desc=CFdescripcion";
		if (dato.value != "") {
			document.getElementById("fr").src="/cfmx/sif/cm/operacion/cfuncionalquery.cfm?dato="+dato.value+"&form=form1"+params;
		}
		else{
			document.form1.CFid.value = "";
			document.form1.CFcodigo.value = "";
			document.form1.CFdescripcion.value = "";
		}
		return;
	}
	
	function limpiarDetalle() {
		//Artículo
		limpiarArticulo();
		//Servicio
		limpiarServicio();
		//Activo
		limpiarActivo();
		//Descripciones
		limpiarDescripciones();
	}
	function limpiarArticulo(){
		var f = document.form1;
		f.Aid.value="";
		f.Acodigo.value="";
		f.Adescripcion.value="";
	}
	function limpiarServicio(){
		var f = document.form1;
		f.Cid.value="";
		f.Cdescripcion.value="";	
	}
	function limpiarActivo(){
		var f = document.form1;
		if (f.ACcodigo.length > 0)
			f.ACcodigo.options[0].selected = true;
		cambiar_categoria();
	}
	function limpiarDescripciones(){
		var f = document.form1;
		f.DOdescripcion.value="";
		f.DOalterna.value="";
		f.DOobservaciones.value="";
	}
	function cambiarDetalle(){		
		var f = document.form1;
		var _divArticulo = document.getElementById("divArticulo");
		var _EtiArticulo = document.getElementById("EtiArticulo");
		var _divAlmacen = document.getElementById("divAlmacen");
		var _EtiAlmacen = document.getElementById("EtiAlmacen");
		var _divConcepto = document.getElementById("divConcepto");
		var _EtiConcepto = document.getElementById("EtiConcepto");
		var _divActivo = document.getElementById("divActivo");
		var _EtiActivo = document.getElementById("EtiActivo");
		var _divClasificacion = document.getElementById("divClasificacion");
		var _EtiClasificacion = document.getElementById("EtiClasificacion");
		if(f.CMtipo.value=="A"){
			_divArticulo.style.display = '';
			_divAlmacen.style.display = '';
			_EtiArticulo.style.display = '';
			_EtiAlmacen.style.display = '';
			_divConcepto.style.display = 'none';
			_EtiConcepto.style.display = 'none';
			_divActivo.style.display = 'none';
			_EtiActivo.style.display = 'none';
			_divClasificacion.style.display = 'none';
			_EtiClasificacion.style.display = 'none';
			f.DOdescripcion.disabled = true;
		}else if(f.CMtipo.value=="S"){
			_divArticulo.style.display = 'none';
			_EtiArticulo.style.display = 'none';
			_divAlmacen.style.display = 'none';	
			_EtiAlmacen.style.display = 'none';		
			_divConcepto.style.display = '';
			_EtiConcepto.style.display = '';
			_divActivo.style.display = 'none';
			_EtiActivo.style.display = 'none';
			_divClasificacion.style.display = 'none';
			_EtiClasificacion.style.display = 'none';
			f.DOdescripcion.disabled = true;
		}else if(f.CMtipo.value=="F") {
			_divArticulo.style.display = 'none';
			_EtiArticulo.style.display = 'none';
			_divAlmacen.style.display = 'none';
			_EtiAlmacen.style.display = 'none';
			_divConcepto.style.display = 'none';
			_EtiConcepto.style.display = 'none';
			_divClasificacion.style.display = '';
			_EtiClasificacion.style.display = '';
			_divActivo.style.display = '';
			_EtiActivo.style.display = '';
			f.DOdescripcion.disabled = false;
		}
	}
	function cambiar_categoria() {
		var categoria = document.form1.ACcodigo.value;
		var combo = document.form1.ACid;
		var cont = 0;
		combo.length=0;
		<cfoutput query="rsClasificacion">
			if (#Trim(rsClasificacion.ACcodigo)#==trim(categoria)) 
			{
				combo.length=cont+1;
				combo.options[cont].value='#rsClasificacion.ACid#';
				combo.options[cont].text='#rsClasificacion.ACdescripcion#';
				<cfif mododet NEQ "ALTA" and #rsClasificacion.ACid# EQ #rsLinea.ACid#>
					combo.options[cont].selected=true;
				</cfif>
				cont++;
			};
		</cfoutput>
	}
	function cambiar_unidades(seleccionar){
		var tipo = document.form1.CMtipo.value;
		var combo = document.form1.Ucodigo;
		var cont = 0;
		combo.length=0;
		<cfoutput query="rsUnidades">
			if ((tipo=="A"&&(#rsUnidades.Utipo#==0||#rsUnidades.Utipo#==2))
					||(tipo=="S"&&(#rsUnidades.Utipo#==1||#rsUnidades.Utipo#==2))
					||(tipo=="F"&&(#rsUnidades.Utipo#==0||#rsUnidades.Utipo#==2))) 
			{
				combo.length=cont+1;
				combo.options[cont].value='#rsUnidades.Ucodigo#';
				combo.options[cont].text='#rsUnidades.Udescripcion#';
				<cfif (mododet EQ "CAMBIO") and #rsUnidades.Ucodigo# EQ #rsLinea.Ucodigo#>
					combo.options[cont].selected=true;
				<cfelse>
					if (seleccionar && seleccionar == '#rsUnidades.Ucodigo#')
						combo.options[cont].selected=true;
				</cfif>
				cont++;
			};
		</cfoutput>
		<cfif (mododet EQ "CAMBIO")>
			document.form1.Ucodigo.disabled = true;
		<cfelse>
			document.form1.Ucodigo.disabled = false;
		</cfif>		
	}
	function funcAcodigo(){
		var f = document.form1;
		cambiar_unidades(f._Ucodigo_Aid.value);
		f.Ucodigo.disabled = f._Ucodigo_Aid.value.length>0;
		f.DOdescripcion.value=f.Adescripcion.value;
		document.form1.Icodigo.value = trim(document.form1.Icodigo_Acodigo.value)!='' ? trim(document.form1.Icodigo_Acodigo.value) : '';
		//f.DOalterna.value=f.Adescripcion.value;
		//f.DOobservaciones.value=f.Adescripcion.value;
	}
	function funcCcodigo(){
		var f = document.form1;
		f.DOdescripcion.value=f.Cdescripcion.value;
		//f.DOalterna.value=f.Cdescripcion.value;
		//f.DOobservaciones.value=f.Cdescripcion.value;
	}
	function info(){
		open('solicitudes-info.cfm?observaciones=DOobservaciones&descalterna=DOalterna&titulo=Ordenes de Compra&ver=SI', 'ordenes', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=420,left=250, top=200,screenX=250,screenY=200');
	}	
	//-->
</script>
<style type="text/css">
<!--
.style2 {
	font-size: 16px;
	color: #FF0000;
	font-weight: bold;
}
-->
</style>



<br>
<cfoutput>

<input type="hidden" name="cambioDescuentos" value="0">

<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="subTitulo"><font size="2">Detalle de Orden de Compra</font></td>
  </tr>
</table>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="21%" align="right"><strong>Item:</strong></td>
    <td colspan="3">
      <table width="100%" border="0">
        <tr>
          <td nowrap>
		  <cfif (modoDet EQ "CAMBIO")>
			<cfif rsLinea.CMtipo EQ "A">
				<input type="hidden" name="CMtipo" value="A">
				Art&iacute;culo
			<cfelseif rsLinea.CMtipo EQ "S">
				<input type="hidden" name="CMtipo" value="S">
				Concepto
			<cfelseif rsLinea.CMtipo EQ "F">	
				<input type="hidden" name="CMtipo" value="F">			
				Activo
			</cfif>	  
		  <cfelse>
            <select name="CMtipo" onChange="javascript:limpiarDetalle();cambiarDetalle();cambiar_unidades();" tabindex="2">
              <cfif rsItems.CMTStarticulo eq 1 or allowAllItems>
                <option value="A">Art&iacute;culo</option>
              </cfif>
              <cfif rsItems.CMTSservicio eq 1 or allowAllItems>
                <option value="S">Concepto</option>
              </cfif>
              <cfif rsItems.CMTSactivofijo eq 1 or allowAllItems>
                <option value="F">Activo</option>
              </cfif>
            </select>		  
		  </cfif>

          </td>
          <td width="1%" align="right" nowrap>
            <div id="EtiAlmacen" style="display: none ;" ><strong>Almac&eacute;n:&nbsp;</strong></div>
            <div id="EtiActivo" style="display: none ;" ><strong>Categor&iacute;a:&nbsp;</strong></div></td>
          <td width="45%" nowrap>
            <div id="divAlmacen" style="display:none">
              <cfif mododet neq 'ALTA' and isdefined('rsLinea') and rsLinea.Alm_Aid NEQ ''>
				<cfquery name="rsAlmac" datasource="#session.DSN#">
					select Aid, Almcodigo, Bdescripcion
					from Almacen
					where Ecodigo=#session.Ecodigo#
						and Aid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.Alm_Aid#">
				</cfquery>			  
				<cfif isdefined('rsAlmac') and rsAlmac.recordCount GT 0>
					<input name="Almcodigo" readonly="true" tabindex="3" 
						type="text" value="#rsAlmac.Almcodigo#" size="15" maxlength="20">				
					<input name="Bdescripcion" readonly="true" tabindex="3" 
						type="text" value="#rsAlmac.Bdescripcion#" size="20" maxlength="60">				
				</cfif>
              <cfelse>
                <cf_sifalmacen size="15" aid="Almacen" >
              </cfif>
            </div>
            <div id="divActivo" style="display:none">
				<cfif mododet EQ 'ALTA'>
				  <select name="ACcodigo" onChange="javascript:cambiar_categoria();" tabindex="2" >
					<cfloop query="rsCategorias">
						<option value="#rsCategorias.ACcodigo#">#rsCategorias.ACdescripcion#</option>
					</cfloop>
				  </select>
				<cfelse>
					<input type="hidden" name="ACcodigo" value="#rsLinea.ACcodigo#">
					#rsCategorias.ACdescripcion#
				</cfif>
          	</div>
		  </td>
          <!--- Articulo, clasificacion y servicio --->
          <td align="right" width="1%" valign="middle" nowrap>
            <div id="EtiArticulo" style="display: none ;" ><strong>Art&iacute;culo:&nbsp;</strong></div>
            <div id="EtiClasificacion" style="display: none ;" ><strong>Clasificaci&oacute;n:&nbsp;</strong></div>
            <div id="EtiConcepto" style="display: none ;" ><strong>Servicio:&nbsp;</strong></div></td>
          <td nowrap>
            <div id="divConcepto" style="display:none">
              <cfif mododet neq 'ALTA'>
              	  <cfif rsModificaOC.value NEQ 0 and rsLinea.EOestado EQ 5>
               		 <cf_sifconceptos query="#rsLinea#" desc="Cdescripcion" tabindex="2" readOnly="yes">
                <cfelse>
               		 <cf_sifconceptos query="#rsLinea#" desc="Cdescripcion" tabindex="2">
                </cfif>
                <cfelse>
                <cf_sifconceptos desc="Cdescripcion" tabindex="2">
              </cfif>
            </div>
            
            <div id="divArticulo" style="display:none">
			  <cfif mododet neq 'ALTA'>
              	<cfif rsLinea.CMtipo eq 'A'>
					<cfif isdefined('rsLinea') and rsLinea.Aid NEQ ''>
						<cfquery name="rsArtic" datasource="#session.DSN#">
							select Aid, Adescripcion
							from Articulos
							where Ecodigo=#session.Ecodigo#
								and Aid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.Aid#">
						</cfquery>			  
						
						<cfif isdefined('rsArtic') and rsArtic.recordCount GT 0>
							#rsArtic.Adescripcion#
						</cfif>
					</cfif>

                	<!--- <cf_sifarticulos form="form1" id="Aid" almacen="Almacen" query="#rsLinea#" tabindex="2"> --->
                <cfelse>
                  	<input type="hidden" name="Aid" value="-1">
                </cfif>
              <cfelse>
                <cf_sifarticulos form="form1" id="Aid" almacen="Almacen" tabindex="2">
              </cfif>
            </div>
          
            <div id="divClasificacion" style="display:none">
            <cfif (modoDet EQ "CAMBIO") and rsModificaOC.value NEQ 0 and rsLinea.EOestado EQ 5>
              <select name="ACid" tabindex="2" disabled="disabled">
              </select>
             <cfelse>
              <select name="ACid" tabindex="2">
              </select>
             </cfif>
          </div></td>
        </tr>
    </table></td>
    <td width="12%" align="right"><strong>Cantidad:</strong></td>
    <td width="12%" align="left">
		<cfif (modoDet EQ "CAMBIO")>
			#LSCurrencyFormat(rsLinea.DOcantidad,'none')#
		<cfelse>
			0.00
		</cfif>
	</td>
  </tr>
  <tr>
    <td align="right"><strong>Impuesto:</strong></td>
    <td width="31%" align="left">
		<cfif (modoDet EQ "CAMBIO")>
			<cfif isdefined('rsImpuestos') and rsImpuestos.Idescripcion NEQ ''>
				&nbsp;&nbsp;#rsImpuestos.Idescripcion#
			</cfif>
		<cfelse>
			<select name="Icodigo"  onChange="javascript:calcular_totales();" tabindex="4">
			  <option value="">No especificado</option>           
			  <cfloop query="rsImpuestos">
				<option value="#trim(rsImpuestos.Icodigo)#" <cfif mododet neq 'ALTA' and rsLinea.Icodigo eq rsImpuestos.Icodigo >selected</cfif>> #rsImpuestos.Idescripcion#</option>
			  </cfloop>
			</select>		
		</cfif>
	</td>
    <td width="12%" align="right"><strong>Unidad:</strong></td>
    <td width="12%" nowrap>
		<div align="left">
		  <select name="Ucodigo" tabindex="4">
		  </select>			  
	    </div>	
	</td>
    <td align="right" nowrap><strong>Precio Unitario:</strong></td>
    <td align="left">
		<cfif (modoDet EQ "CAMBIO")>
			#LvarOBJ_PrecioU.enCF_RPT(rsLinea.DOpreciou)#
		<cfelse>
			#LvarOBJ_PrecioU.enCF_RPT(0)#
		</cfif>	
	</td>
  </tr> 
  <tr>
    <td align="right"><strong>Descripci&oacute;n:</strong></td>
    <td nowrap>
		<cfif (modoDet EQ "CAMBIO")>
			&nbsp;&nbsp;#rsLinea.DOdescripcion#
			<input type="hidden" name="DOdescripcion" value="#rsLinea.DOdescripcion#">
		  	&nbsp;<a href="javascript:info();"><img border="0" src="../../imagenes/iedit.gif" alt="<cfif modoDet eq 'ALTA'>Definir<cfelse>Ver/Modificar</cfif> informac&oacute;n adicional (Descripci&oacute;n alterna, Observaciones)"></a> </td>			
		<cfelse>
			<input name="DOdescripcion" tabindex="3" onFocus="javascript:document.form1.DOdescripcion.select();" type="text" value="" size="50" maxlength="255">
		</cfif>
	</td>
    <td align="right" nowrap><strong>% Descuento:</strong></td>
    <td>
		<cfif (modoDet EQ "CAMBIO")>
			#LSCurrencyFormat(rsLinea.DOporcdesc,'none')#
		<cfelse>
			0.0000
		</cfif>
	</td>
    <td align="right" nowrap><strong>Monto Descuento:</strong></td>
    <td>
		<cfif (modoDet EQ "CAMBIO")>
			#LSCurrencyFormat(rsLinea.DOmontodesc,'none')#
		<cfelse>
			0.00
		</cfif>
	</td>
  </tr>
  <tr>
    <td align="right" nowrap><strong>Fecha Requerida:</strong></td>
    <td>
		<cfif mododet EQ "CAMBIO">
			&nbsp;&nbsp;#LSDateFormat(rsLinea.DOfechareq,'dd/mm/yyyy')#
		<cfelse>
			<cf_sifcalendario name="DOfechareq" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="3">
		</cfif>	
	</td>
    <td align="right"><strong>Garant&iacute;a:</strong></td>
    <td>
		<input 	type="text" name="DOgarantia" style="text-align:right" tabindex="3"
				onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
				onFocus="javascript:this.select();" 
				onChange="javascript:fm(this,0);" 
				<cfif (mododet EQ "CAMBIO")> readonly="true"</cfif>
				value="<cfif (mododet EQ "CAMBIO")>#rsLinea.DOgarantia#<cfelse>0</cfif>" size="5" maxlength="5">
				d&iacute;as.		
	</td>
    <td align="right"><strong>Pa&iacute;s:</strong></td>
    <td nowrap>
		<cfif (modoDet EQ "CAMBIO") and rsLinea.Ppais NEQ ''>
			&nbsp;&nbsp;#HTMLEditFormat(rsPais.Pnombre, -1)#
		<cfelseif trim(rsPaisSocio.Ppais) NEQ '' and isdefined('rsPais') and rsPais.recordCount GT 0>
			&nbsp;&nbsp;#HTMLEditFormat(rsPais.Pnombre, -1)#
		<cfelse>
			<select name="Ppais">
			  <cfloop query="rsPais">
				<option value="#rsPais.Ppais#" <cfif modoDet neq 'ALTA' and trim(rsPais.Ppais) eq trim(rsLinea.Ppais) >selected<cfelseif trim(rsPais.Ppais) eq trim(rsPaisSocio.Ppais) >selected</cfif> >#HTMLEditFormat(rsPais.Pnombre, -1)#</option>
			  </cfloop>
			</select>		
		</cfif>
	</td>
  </tr>
  <tr>
    <td align="right" nowrap><strong>Centro Funcional:</strong></td>
    <td nowrap>
		<cfif (mododet EQ "CAMBIO")>
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						&nbsp;&nbsp;&nbsp;#rsLinea.CFcodigo#&nbsp;-&nbsp;
					</td>
					<td nowrap>
						#rsLinea.CFdescripcion#
					</td>
				</tr>
			</table>
		<cfelse>
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="1%">
						<input type="text" name="CFcodigo" id="CFcodigo" tabindex="3" 
							value="<cfif (mododet EQ "CAMBIO")>#rsLinea.CFcodigo#</cfif>" 
							onBlur="javascript: TraeCFuncional(this); " size="10" maxlength="10" 
							onFocus="javascript:this.select();">
						<input type="hidden" name="CFid" value="<cfif (mododet EQ "CAMBIO")>#rsLinea.CFid#</cfif>">
					</td>
					<td nowrap>
						<input type="text" name="CFdescripcion" id="CFdescripcion" tabindex="3" 
							disabled value="<cfif (mododet EQ "CAMBIO")>#rsLinea.CFdescripcion#</cfif>" 
							size="40" 
							maxlength="80">
						<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Centros Funcionales" name="CFimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCFuncional();'></a></td>
				</tr>
			</table>
		</cfif>
		
		<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
		<iframe name="frTotal" id="frTotal" marginheight="0" marginwidth="0" height="0" frameborder="1" width="0" scrolling="auto" src="" ></iframe>	
	</td>
    <td align="right" nowrap><strong>Entrega Est:</strong></td>
    <td>
		<cfif mododet EQ "CAMBIO">
			&nbsp;&nbsp;#LSDateFormat(rsLinea.DOfechaes,'dd/mm/yyyy')#
		<cfelse>
			<cf_sifcalendario name="DOfechaes" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="3">
		</cfif>	
	</td>
    <td align="right">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td align="right">&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <cfif (mododet EQ "CAMBIO") and rsLinea.EOestado EQ 5 and rsModificaOC.value EQ 0>
  		<input  type="hidden" name="EOestado" value="#rsLinea.EOestado#">		
  </cfif> 
</table>

    <input name="DOobservaciones" type="hidden" value=""> 
    <input name="DOalterna" 	  type="hidden" value="">
	<input name="ts_rversionD" 	  type="hidden" value="<cfif (modoDet EQ "CAMBIO")>#tsD#</cfif>">
    <input name="DOlinea" 		  type="hidden" value="<cfif (modoDet EQ "CAMBIO")>#rsLinea.DOlinea#</cfif>">
</cfoutput>
<cfsavecontent variable="qformsNombresCamposDetalle">
<cfoutput>
	objForm.CMtipo.description 			= "#JSStringFormat('Item')#";
	objForm.Almacen.description 		= "#JSStringFormat('Almacén')#";
	objForm.Aid.description				= "#JSStringFormat('Artículo')#";
	objForm.Cid.description 			= "#JSStringFormat('Concepto')#";
	objForm.ACcodigo.description 		= "#JSStringFormat('Categoría')#";
	objForm.ACid.description 			= "#JSStringFormat('Clase')#";
	objForm.DOdescripcion.description 	= "#JSStringFormat('Descripción')#";
	objForm.CFid.description 			= "#JSStringFormat('Centro Funcional')#";
	objForm.DOgarantia.description 		= "#JSStringFormat('Garantía')#";
	objForm.DOfechaes.description 		= "#JSStringFormat('Fecha estimada de entrega')#";
	objForm.DOcantidad.description 		= "#JSStringFormat('Cantidad')#";
	objForm.DOpreciou.description 		= "#JSStringFormat('Precio Unitario')#";
	objForm.Ucodigo.description 		= "#JSStringFormat('Unidad')#";
	objForm.Icodigo.description 		= "#JSStringFormat('Impuesto')#";
</cfoutput>
</cfsavecontent>

<cfsavecontent variable="qformsHabilitarValidacionDetalle">
	if (objForm.botonSel.getValue()=="AltaDet"||objForm.botonSel.getValue()=="CambioDet"){
		objForm.CMtipo.required = true;
		if (objForm.CMtipo.getValue()=="A"){
			objForm.Almacen.required = true;
			objForm.Aid.required = true;
			objForm.Cid.required = false;
			objForm.ACcodigo.required = false;
			objForm.ACid.required = false;
		}else if (objForm.CMtipo.getValue()=="S"){
			objForm.Almacen.required = false;
			objForm.Aid.required = false;
			objForm.Cid.required = true;
			objForm.ACcodigo.required = false;
			objForm.ACid.required = false;
		}else if (objForm.CMtipo.getValue()=="F"){
			objForm.Almacen.required = false;
			objForm.Aid.required = false;
			objForm.Cid.required = false;
			objForm.ACcodigo.required = true;
			objForm.ACid.required = true;
		}
		objForm.DOdescripcion.required = true;
		objForm.CFid.required = true;
		objForm.DOgarantia.required = true;
		objForm.DOfechaes.required = true;
		objForm.DOcantidad.required = true;
		objForm.DOcantidad.validatePositiveFloat();
		objForm.DOpreciou.required = true;
		objForm.DOpreciou.validatePositiveFloat4();
		objForm.Ucodigo.required = true;
		objForm.Icodigo.required = true;
	}
	else
	{
		objForm.CMtipo.required = false;
		objForm.Almacen.required = false;
		objForm.Aid.required = false;
		objForm.Cid.required = false;
		objForm.ACcodigo.required = false;
		objForm.ACid.required = false;
		objForm.DOdescripcion.required = false;
		objForm.CFid.required = false;
		objForm.DOgarantia.required = false;
		objForm.DOfechaes.required = false;
		objForm.DOcantidad.required = false;
		objForm.DOpreciou.required = false;
		objForm.Ucodigo.required = false;
		objForm.Icodigo.required = false;
	}
</cfsavecontent>
<cfsavecontent variable="qformsDesHabilitarValidacionDetalle">
	objForm.CMtipo.required 		= false;
	objForm.Almacen.required 		= false;
	objForm.Aid.required 			= false;
	objForm.Cid.required 			= false;
	objForm.ACcodigo.required 		= false;
	objForm.ACid.required 			= false;
	objForm.DOdescripcion.required 	= false;
	objForm.CFid.required 			= false;
	objForm.DOgarantia.required 	= false;
	objForm.DOfechaes.required 		= false;
	objForm.DOcantidad.required 	= false;
	objForm.DOpreciou.required 		= false;
	objForm.Ucodigo.required 		= false;
	objForm.Icodigo.required 		= false;
</cfsavecontent>
<cfsavecontent variable="qformsFinalizarValidacionDetalle">
	objForm.DOcantidad.obj.value 		= qf(objForm.DOcantidad.obj.value);
	objForm.DOpreciou.obj.value 		= qf(objForm.DOpreciou.obj.value);
	objForm.CMtipo.obj.disabled 		= false;
	objForm.Ucodigo.obj.disabled 		= false;
	objForm.DOdescripcion.obj.disabled 	= false;
</cfsavecontent>
<cfsavecontent variable="qformsFocusOnDetalle">
	cambiarDetalle();
	cambiar_categoria();
	cambiar_unidades();
	<cfif (mododet EQ "CAMBIO")>
		<cfif (rsLinea.CMtipo EQ "A")>
			objForm.Almcodigo.obj.focus();
		<cfelseif (rsLinea.CMtipo EQ "S")>
			objForm.Ccodigo.obj.focus();
		<cfelseif (rsLinea.CMtipo EQ "F")>
			objForm.ACcodigo.obj.focus();
		</cfif>
	<cfelse>
		objForm.CMtipo.obj.focus();
	</cfif>
</cfsavecontent>

<script type="text/javascript" language="javascript1.2">
	function calcular_totales(){
		var paramTotal = "?form=form1&EOidorden="+ document.form1.EOidorden.value + "&DOcantidad="+document.form1.DOcantidad.value + "&DOpreciou="+document.form1.DOpreciou.value + "&Icodigo=" + trim(document.form1.Icodigo.value) + "&EOdesc=" + trim(document.form1.EOdesc.value) + "&modo=<cfoutput>#mododet#</cfoutput>";
		<cfif mododet neq 'ALTA'>
			paramTotal += "&DOlinea=" + document.form1.DOlinea.value;
		</cfif>
		document.getElementById("frTotal").src="/cfmx/sif/cm/operacion/orden-total.cfm" + paramTotal;
	}
	
	function calculaPorcenDesc(obj){		
		obj.form.cambioDescuentos.value=1;	
		if(obj.form.DOpreciou.value != '' && qf(obj.form.DOpreciou.value) > 0 && obj.form.DOcantidad.value != '' && qf(obj.form.DOcantidad.value) > 0){
			var porcDesc = 0;
			var totalPagar = qf(obj.form.DOpreciou.value) * qf(obj.form.DOcantidad.value);
			var valorMontoDesc = qf(obj.value);
					
			if(totalPagar > 0 && ESNUMERO(valorMontoDesc) && valorMontoDesc > 0){
				if(valorMontoDesc <= totalPagar){
					porcDesc = (valorMontoDesc * 100) / totalPagar;
					obj.form.DOmontodesc.value = valorMontoDesc;
					obj.form.DOporcdesc.value = porcDesc;
					obj.form.DOporcdesc_tmp.value = porcDesc;			
					fm(obj.form.DOporcdesc,4);
					fm(obj.form.DOporcdesc_tmp,4);
					obj.form.DOporcdesc_tmp.disabled=1;
				}else{
					alert('Error, monto del porcentaje inválido, no se permiten montos superiores al total de la linea que es de ' + totalPagar);
					obj.form.DOmontodesc_tmp.value = '0.0000';
					obj.form.DOmontodesc.value = '0.0000';
					obj.form.DOporcdesc.value = '0.0000';
					obj.form.DOporcdesc_tmp.value = '0.0000';			
					obj.form.DOporcdesc_tmp.disabled=0;			
				}
			}else{
				obj.form.DOmontodesc.value = '0.0000';
				obj.form.DOporcdesc.value = '0.0000';
				obj.form.DOporcdesc_tmp.value = '0.0000';			
				obj.form.DOporcdesc_tmp.disabled=0;
			}
		}else{
			alert('Debe digitar primero la cantidad y el precio unitario');
			obj.form.DOmontodesc.value = '0.0000';
			obj.form.DOmontodesc_tmp.value = '0.0000';			
			obj.form.DOporcdesc.value = '0.0000';
			obj.form.DOporcdesc_tmp.value = '0.0000';			
		}
	}
	
	function calculaMontoDesc(obj){		
		obj.form.cambioDescuentos.value=1;		
		if(obj.form.DOpreciou.value != '' && qf(obj.form.DOpreciou.value) > 0 && obj.form.DOcantidad.value != '' && qf(obj.form.DOcantidad.value) > 0){	
			var montoDesc = 0;
			var totalPagar = qf(obj.form.DOpreciou.value) * qf(obj.form.DOcantidad.value);
			var valorPorcDesc = qf(obj.value);
				
			if(ESNUMERO(valorPorcDesc) && valorPorcDesc > 0){
				if(valorPorcDesc <= 100){
					montoDesc = (totalPagar * valorPorcDesc) / 100;
					obj.form.DOporcdesc.value = valorPorcDesc;
					obj.form.DOmontodesc.value = montoDesc;
					obj.form.DOmontodesc_tmp.value = montoDesc;			
					fm(obj.form.DOmontodesc,4);
					fm(obj.form.DOmontodesc_tmp,4);
					obj.form.DOmontodesc_tmp.disabled=1;			
				}else{
					alert('Error, porcentaje inválido, no se permiten montos superiores a 100');
					obj.form.DOporcdesc_tmp.value = '0.0000';
					obj.form.DOporcdesc.value = '0.0000';
					obj.form.DOmontodesc.value='0.0000';
					obj.form.DOmontodesc_tmp.value='0.0000';
					obj.form.DOmontodesc_tmp.disabled=0;				
				}
			}else{
				obj.form.DOporcdesc.value = '0.0000';
				obj.form.DOmontodesc.value='0.0000';
				obj.form.DOmontodesc_tmp.value='0.0000';
				obj.form.DOmontodesc_tmp.disabled=0;
			}
		}else{
			alert('Debe digitar primero la cantidad y el precio unitario');
			obj.form.DOporcdesc.value = '0.0000';
			obj.form.DOporcdesc_tmp.value = '0.0000';			
			obj.form.DOmontodesc.value='0.0000';
			obj.form.DOmontodesc_tmp.value='0.0000';
		}		
	}	
	
	function calculaDescuentos(obj){
		if(ESNUMERO(obj.value) && obj.value > 0){
			if(ESNUMERO(obj.form.DOporcdesc_tmp.value) && obj.form.DOporcdesc_tmp.value > 0){
				calculaMontoDesc(obj.form.DOporcdesc_tmp);
			}
		}else{
			obj.form.DOmontodesc.value = '0.0000';
			obj.form.DOmontodesc_tmp.value = '0.0000';			
			obj.form.DOporcdesc.value = '0.0000';
			obj.form.DOporcdesc_tmp.value = '0.0000';	
			
			obj.form.DOporcdesc_tmp.disabled = 0;	
			obj.form.DOmontodesc_tmp.disabled = 0;
		}
	}
</script>