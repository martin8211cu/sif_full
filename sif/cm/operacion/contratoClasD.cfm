<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfif isdefined("url.DOlinea") and len(trim(url.DOlinea))><cfset form.DOlinea = url.DOlinea></cfif>
<cfif isdefined("url.Contid") and len(trim(url.Contid))><cfset form.Contid = url.Contid></cfif>
<cfparam name="mododet" default="ALTA">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfif not isdefined('lvarFiltroEcodigo') or len(trim(#lvarFiltroEcodigo#)) eq 0 >
  <cfset lvarFiltroEcodigo = #session.Ecodigo#>
</cfif>

<!---►►Actividad Empresarial (N-No se usa AE, S-Se usa Actividad Empresarial)◄◄--->
<cfquery name="rsActividad" datasource="#session.DSN#">
  Select Coalesce(Pvalor,'N') as Pvalor
  	from Parametros
   where Pcodigo = 2200
     and Mcodigo = 'CG'
     and Ecodigo = #lvarFiltroEcodigo#
</cfquery>
<!---►►Formular Por(0-Plan de Cuentas,1-Plan de Compras)◄◄--->
<cfquery name="rsFormularPor" datasource="#session.DSN#">
  Select Coalesce(Pvalor,'0') as Pvalor
  	from Parametros
   where Pcodigo = 2300
     and Mcodigo = 'CG'
     and Ecodigo = #lvarFiltroEcodigo#
</cfquery>

<cfquery name="rsDcontrato" datasource="#Session.DSN#">
	select c.CPDDid,c.Ccodigo,c.CPDCid, c.CMtipo, ltrim(rtrim(cf.CFcodigo)) CFcodigo,
	cf.CFdescripcion, c.CFid, c.CPDEid
    from CTDetContrato c
    left join CFuncional cf
        on c.CFid = cf.CFid
    where CTDCont = #form.Contid#
</cfquery>


<!--- Consultas --->
<cfif isdefined("form.DOlinea") and len(trim(form.DOlinea))>
	<!--- Detalle de la Línea --->
	<cfquery name="rsLinea" datasource="#Session.DSN#">
		select eo.EOestado,a.DOlinea,a.Ecodigo,a.EOidorden,a.EOnumero,a.DOconsecutivo,
			a.ESidsolicitud,a.DSlinea,a.CMtipo,a.Cid,a.Aid,a.Alm_Aid,a.ACcodigo,
			a.ACid,a.CFid,a.Icodigo,a.Ucodigo,a.DOdescripcion,a.DOalterna,
			a.DOobservaciones,a.DOcantidad,a.DOcantsurtida,
			#LvarOBJ_PrecioU.enSQL_AS("a.DOpreciou")#,
			a.DOtotal,a.DOfechaes,a.DOgarantia,a.ts_rversion <!---Campos del Encabezado------->
			,f.Acodigo,f.Adescripcion 						 <!---Campos de Artículos--------->
			,g.Ccodigo,g.Cdescripcion 						 <!---Campos de Conceptos--------->
			,c.CFcodigo,c.CFdescripcion 					 <!---Campos de CentroFuncional--->
			,a.DOfechareq, a.Ppais,
			DOmontodesc, DOporcdesc,a.FPAEid, a.CFComplemento, a.CPDDid,a.DClinea, b.Idescripcion
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
				on e.Aid = a.Alm_Aid
			left outer join Articulos f
				on f.Aid = a.Aid
			left outer join Conceptos g
				on g.Cid = a.Cid
		where a.Ecodigo = #lvarFiltroEcodigo#
		  and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		  and a.DOlinea   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DOlinea#">
	</cfquery>
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp"
		artimestamp="#rsLinea.ts_rversion#"
		returnvariable="tsD">
	</cfinvoke>
	<cfif rsLinea.RecordCount>
        <cfset mododet = "CAMBIO">
    </cfif>

</cfif>

<cfif isdefined("rsOrden") and len(trim(rsOrden.CMTOcodigo))>
	<cfquery name="rsTipoOrdenEncab" datasource="#session.DSN#">
		select CMTOimportacion, CMTgeneratracking
		from CMTipoOrden
		where Ecodigo = #lvarFiltroEcodigo#
			and CMTOcodigo = '#rsOrden.CMTOcodigo#'
	</cfquery>
</cfif>

<cfif isdefined("rsLinea.CPDDid") and len(trim(#rsLinea.CPDDid#)) gt 0>
	<cfquery name="rsCPDD" datasource="#session.DSN#">
		select e.CPDEnumeroDocumento, d.CPDDsaldo
        from CPDocumentoE e
            inner join CPDocumentoD d
            	on d.CPDEid = e.CPDEid
		where d.Ecodigo = #lvarFiltroEcodigo#
			and d.CPDDid = #rsLinea.CPDDid#
	</cfquery>
</cfif>

<cfif isdefined("rsLinea.DSlinea") and len(trim(#rsLinea.DSlinea#)) gt 0>
	<cfquery name="rsSC" datasource="#session.DSN#">
		select e.ESnumero, e.DStotallinest
        from DSolicitudCompraCM e
		where e.Ecodigo = #lvarFiltroEcodigo#
			and e.DSlinea = #rsLinea.DSlinea#
	</cfquery>
</cfif>
<!---Permite modificar las ordenes de compra cuando vienen del registro de solicitudes--->
<cfquery name="rsModificaOC" datasource="#Session.DSN#">
    select Pvalor as value
    from Parametros
    where Ecodigo = #lvarFiltroEcodigo#
      and Pcodigo = 4310
</cfquery>

<!--- Items permitidos coprar al comprador, si no hay ninguno marcado implica que no hay ninguna restricción, por tantose dará permiso para todo--->
<cfquery name="rsItems" datasource="#Session.DSN#">
	select CMTStarticulo, CMTSservicio, CMTSactivofijo,CMTSobra
	from CMCompradores
	where Ecodigo = #session.Ecodigo#
	<cfif isdefined("vnComprador") and len(trim(vnComprador))>
		and CMCid in (#vnComprador#)
	<cfelse>
		and CMCid= #session.compras.comprador#
	</cfif>
</cfquery>
<cfif rsItems.RecordCount eq 0>
	<cf_errorCode	code = "50294" msg = " El Usuario Actual no está definido como comprador!, Acceso Denegado!">
<cfelseif rsItems.CMTStarticulo neq 1 and rsItems.CMTSservicio neq 1 and rsItems.CMTSactivofijo neq 1>
	<cfset allowAllItems = true>
<cfelse>
	<cfset allowAllItems = false>
</cfif>
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
	where Ecodigo = #lvarFiltroEcodigo#
</cfquery>
<!--- Clasificacion --->
<cfquery name="rsClasificacion" datasource="#Session.DSN#">
	select ACid, ACdescripcion, ACcodigo
	from AClasificacion
	where Ecodigo = #lvarFiltroEcodigo#
	order by ACcodigo, ACdescripcion
</cfquery>
<!---Impuetos--->
<cfquery name="rsImpuestos" datasource="#Session.DSN#">
	select Icodigo, Idescripcion
	from Impuestos
	where Ecodigo = #lvarFiltroEcodigo#
</cfquery>
<!---Unidades--->
<cfquery name="rsUnidades" datasource="#session.DSN#">
	select Ucodigo, Udescripcion, Utipo
	from Unidades
	where Ecodigo=#lvarFiltroEcodigo#
</cfquery>

<!---Pais del socio--->
<cfquery name="rsPaisSocio" datasource="#session.DSN#">
	select Ppais
	from SNegocios
	where Ecodigo=#lvarFiltroEcodigo#
	and SNcodigo= #rsOrden.SNcodigo#
</cfquery>

<!---paises--->
<cfquery name="rsPais" datasource="asp">
	select Ppais, Pnombre
	from Pais
	order by Pnombre
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
		params = params + "?CMCid=" + document.form1.vnCMCid.value;
		//params = "?CMCid=<cfoutput>#session.compras.comprador#</cfoutput>&form=form1&id=CFid&name=CFcodigo&desc=CFdescripcion";
		params = params + "&form=form1&id=CFid&name=CFcodigo&desc=CFdescripcion&Ecodigo=<cfoutput>#lvarFiltroEcodigo#</cfoutput>";
		popUpWindow("/cfmx/sif/cm/operacion/ConlisCFuncional.cfm"+params,250,200,650,400);
	}

	//Obtiene la descripción con base al código
	function TraeCFuncional(dato) {
		var params ="";
		params = params + "&CMCid=" + document.form1.vnCMCid.value;
		params = params + "&id=CFid&name=CFcodigo&desc=CFdescripcion&Ecodigo=<cfoutput>#lvarFiltroEcodigo#</cfoutput>";
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
		/*var f = document.form1;
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
		}*/
	}
	function cambiar_categoria() {
		/*var categoria = document.form1.ACcodigo.value;
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
		*/
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
		//document.form1.Ucodigo.disabled = false;
	}
	function funcAcodigo(){
		var f = document.form1;
		cambiar_unidades(f._Ucodigo_Aid.value);
		//f.Ucodigo.disabled = f._Ucodigo_Aid.value.length>0;
		f.DOdescripcion.value=f.Adescripcion.value;
		f.DOalterna.value=f.descalterna.value;
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
		open('solicitudes-info.cfm?observaciones=DOobservaciones&descalterna=DOalterna&titulo=Ordenes de Compra', 'ordenes', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=470,left=250, top=100,screenX=250,screenY=100');
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
<!----ENCAB_OC:<cfdump var="#rsOrden.CMCid#"><br>---->
<!----#vnComprador#----->
<input type="hidden" name="cambioDescuentos" value="0">
<!-----El input vnCMCid es para guardar el Comprador de la OC cuando el usuario logueado es autorizado------>
<input type="hidden" name="vnCMCid"
	value="<cfif isdefined("vnComprador") and len(trim(vnComprador))><cfif isdefined("rsOrden") and len(trim(rsOrden.CMCid))>#rsOrden.CMCid#</cfif><cfelseif isdefined("session.compras.comprador") and len(trim(session.compras.comprador))>#session.compras.comprador#</cfif>">

<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="subTitulo"><font size="2">#t.Translate('LB_DetOC','Detalle de Orden de Compra')#</font></td>
  </tr>
</table>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="21%" align="right"><strong>Item:</strong></td>
    <td colspan="3">
      <table width="100%">
        <tr>
          <td nowrap>
            <select name="CMtipo" id="CMtipo" onChange="javascript:limpiarDetalle();cambiarDetalle();cambiar_unidades();habilitaCheck();habilitaPlantilla();" tabindex="2" >
               <cfif (rsItems.CMTStarticulo eq 1 or allowAllItems) and modoDet EQ "ALTA" and rsOrden.EOestado NEQ 5>
                <option value="A" <cfif (modoDet EQ "CAMBIO") and rsLinea.CMtipo EQ "A">selected</cfif>>#t.Translate('LB_OptArticulo','Artículo')#</option>
               <cfelseif modoDet EQ "CAMBIO" >
			     <option value="A" <cfif (modoDet EQ "CAMBIO") and rsLinea.CMtipo EQ "A">selected</cfif>>#t.Translate('LB_OptArticulo','Artículo')#</option>
			   </cfif>
            </select>

          </td>
          <td width="1%" align="right" nowrap>
            <div id="EtiAlmacen" ><strong>#t.Translate('LB_Almacen','Almac&eacute;n')#:&nbsp</strong></div>
          <td width="45%" nowrap>
            <div id="divAlmacen">
              <cfif mododet neq 'ALTA'>
              	  <cfif rsModificaOC.value NEQ 0 and rsLinea.EOestado EQ 5>
               		 <cf_sifalmacen  id="#rsLinea.Alm_Aid#"  size="15" aid="Almacen" Ecodigo="#lvarFiltroEcodigo#" readOnly="yes" >
                   <cfelse>
               		 <cf_sifalmacen id="#rsLinea.Alm_Aid#"  size="15" aid="Almacen" Ecodigo="#lvarFiltroEcodigo#">
                   </cfif>
                <cfelse>
                <cf_sifalmacen size="15" aid="Almacen" Ecodigo="#lvarFiltroEcodigo#">
              </cfif>
            </div>
        </td>
          <!--- Articulo, clasificacion y servicio --->
          <td align="right" width="1%" valign="middle" nowrap>
            <div id="EtiArticulo" ><strong>#t.Translate('LB_OptArticulo','Artículo')#:&nbsp;</strong></div>
          <td nowrap>
            <div id="divArticulo" >
			  <cfif mododet neq 'ALTA'>
              	<cfif rsLinea.CMtipo eq 'A'>
              	  <cfif rsModificaOC.value NEQ 0 and rsLinea.EOestado EQ 5>
                	<cf_sifarticulos form="form1" id="Aid" almacen="Almacen" query="#rsLinea#" tabindex="2" readOnly="yes" >
                  <cfelse>
                	<cf_sifarticulos form="form1" id="Aid" almacen="Almacen" query="#rsLinea#" tabindex="2">
                  </cfif>
                <cfelse>
                  	<input type="hidden" name="Aid" value="-1">
                </cfif>
              <cfelse>
				<cf_sifarticulos form="form1" id="Aid" almacen="Almacen" Ecodigo="#lvarFiltroEcodigo#" tabindex="2" Ccodigo="#rsDcontrato.Ccodigo#">
              </cfif>
            </div>
          </td>
        </tr>
    </table></td>
    <td width="12%" align="right"><strong>#t.Translate('LB_Cantidad','Cantidad')#:&nbsp;</strong></td>
    <td width="12%" align="right"><input name="DOcantidad" onFocus="javascript:this.select();" type="text" tabindex="4" style="text-align:right" onBlur="javascript:fm(this,2); calcular_totales();" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();} calculaDescuentos(this);}" value="<cfif (modoDet EQ "CAMBIO")>#LSCurrencyFormat(rsLinea.DOcantidad,'none')#<cfelse>0.00</cfif>" size="18" maxlength="18"></td>
  </tr>
  <tr>
  	<!---►►Linea de Impuestos◄◄--->
    <td align="right"><strong>#t.Translate('LB_Impuesto','Impuesto')#:&nbsp;</strong></td>
    <td width="31%">
		<cfif (lcase(mododet) eq 'cambio') and isdefined('rsLinea') and rsLinea.RecordCount gt 0 and rsLinea.Icodigo neq '' >
            <cfset Icodigo 		= rsLinea.Icodigo>
            <cfset Idescripcion = rsLinea.Idescripcion>
        <cfelse>
            <cfset Icodigo = ''>
            <cfset Idescripcion =''>
        </cfif>
      <div align="left">
         <cf_conlis
            Campos="Icodigo,Idescripcion"
            tabindex="6"
            Desplegables="S,S"
            Modificables="S,N"
            values="#Icodigo#,#Idescripcion#"
            Size="15,35"
            Title="Lista de Impuestos"
            Tabla="Impuestos c"
            Columnas="Icodigo,Idescripcion"
            Filtro="Ecodigo = #lvarFiltroEcodigo# order by Idescripcion"
            Desplegar="Icodigo,Idescripcion"
            Etiquetas="Código,Descripción"
            filtrar_por="Icodigo,Idescripcion"
            Formatos="S,S"
            form="form1"
            Align="left,left"
            Asignar="Icodigo,Idescripcion"
            Asignarformatos="S,S"
            funcion = "calcular_totales()"
            />
    	</div>
    </td>
    <td width="12%" align="right"><strong>#t.Translate('LB_Unidad','Unidad')#:&nbsp;</strong></td>
    <td width="12%" nowrap>
		<div align="left">
			<cfif mododet EQ "CAMBIO">
				<cfquery name="rsUniSel" datasource="#session.DSN#">
					select Ucodigo, Udescripcion, Utipo
					from Unidades
					where Ecodigo=#lvarFiltroEcodigo#
					and Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsLinea.Ucodigo#">
				</cfquery>
				<select name="Ucodigo" tabindex="4">
					<cfloop query="rsUniSel">
						<option value="#trim(rsUniSel.Ucodigo)#" selected>#rsUniSel.Udescripcion#</option>
					</cfloop>
				</select>
			<cfelse>
				  <select name="Ucodigo" tabindex="4">

				  </select>
			</cfif>
	    </div>
	</td>
    <td align="right" nowrap><strong>#t.Translate('LB_PrecioUnitario','Precio Unitario')#:&nbsp;</strong></td>
    <td>
		<div align="left">
			<cfparam name="rsLinea.DOpreciou" default="0">
			#LvarOBJ_PrecioU.inputNumber("DOpreciou", rsLinea.DOpreciou, "4", false, "class", "style", "calcular_totales(); calculaDescuentos(this);", "")#
		</div>
	</td>
  </tr>
  <tr>
    <td align="right"><strong>#t.Translate('LB_Descripcion','Descripci&oacute;n')#:&nbsp;</strong></td>
    <td nowrap>
     	 <input name="DOdescripcion" tabindex="3" onFocus="javascript:document.form1.DOdescripcion.select();" type="text" value="<cfif (modoDet EQ "CAMBIO")>#HTMLEditFormat(rsLinea.DOdescripcion)#</cfif>" size="50" maxlength="255">
	  	&nbsp;<a href="javascript:info();"><img border="0" src="../../imagenes/iedit.gif" alt="<cfif modoDet eq 'ALTA'>Definir<cfelse>Ver/Modificar</cfif> informac&oacute;n adicional (Descripci&oacute;n alterna, Observaciones)"></a> </td>
    <td align="right" nowrap><strong>% Descuento:</strong></td>
    <td>
		<input type="hidden" name="DOporcdesc" value="<cfif (modoDet EQ "CAMBIO")>#LSCurrencyFormat(rsLinea.DOporcdesc,'none')#<cfelse>0.00</cfif>">
		<input name="DOporcdesc_tmp" onFocus="javascript:this.select();" type="text" tabindex="4" style="text-align:right" onBlur="javascript:fm(this,4);" onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();} calculaMontoDesc(this);}" value="<cfif (modoDet EQ "CAMBIO")>#LSCurrencyFormat(rsLinea.DOporcdesc,'none')#<cfelse>0.0000</cfif>" size="18" maxlength="18">
	</td>
    <td align="right" nowrap><strong>#t.Translate('LB_MontoDescuento','Monto Descuento')#:&nbsp;</strong></td>
    <td>
		<input  type="hidden" name="DOmontodesc" value="<cfif (modoDet EQ "CAMBIO")>#LSCurrencyFormat(rsLinea.DOmontodesc,'none')#<cfelse>0.00</cfif>">
		<input name="DOmontodesc_tmp" onFocus="javascript:this.select();" type="text" tabindex="4" style="text-align:right" onBlur="javascript:fm(this,4);" onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();} calculaPorcenDesc(this);}" value="<cfif (modoDet EQ "CAMBIO")>#LSCurrencyFormat(rsLinea.DOmontodesc,'none')#<cfelse>0.0000</cfif>" size="18" maxlength="18">
	</td>
  </tr>
  <tr>
    <td align="right" valign="top" nowrap><strong>Fecha Requerida:</strong></td>
    <td>
    	<table border="0" cellspacing="0" cellpadding="0">
        	<tr>
				<td valign="top">
					<cfif mododet EQ "CAMBIO">
                        <cf_sifcalendario name="DOfechareq" value="#LSDateFormat(rsLinea.DOfechareq,'dd/mm/yyyy')#" tabindex="3">
                    <cfelse>
                        <cf_sifcalendario name="DOfechareq" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="3">
                    </cfif>
                </td>
                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                <td align="right" valign="top" nowrap><strong>#t.Translate('LB_EntregaEst','Entrega Est')#:</strong>&nbsp;</td>
                <td valign="top">
					<cfif mododet EQ "CAMBIO">
                        <cf_sifcalendario name="DOfechaes" value="#LSDateFormat(rsLinea.DOfechaes,'dd/mm/yyyy')#" tabindex="3">
                    <cfelse>
                        <cf_sifcalendario name="DOfechaes" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="3">
                    </cfif>
                </td>
			</tr>
		</table>
	</td>
    <td align="right"><strong>#t.Translate('LB_Grantia','Garant&iacute;a')#:&nbsp;</strong></td>
    <td>
		<input 	type="text" name="DOgarantia" style="text-align:right" tabindex="3"
				onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
				onFocus="javascript:this.select();"
				onChange="javascript:fm(this,0);"
				value="<cfif (mododet EQ "CAMBIO")>#rsLinea.DOgarantia#<cfelse>0</cfif>" size="5" maxlength="5">
				d&iacute;as.
	</td>
    <td align="right"><strong>#t.Translate('LB_MontoTotal','Monto total')#:</strong>&nbsp;</td>
    <td>
		<input name="DOmontoTotal"  onFocus="javascript:this.select();" type="text" tabindex="4" style="text-align:right" onBlur="javascript:fm(this,4);" onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();} }" disabled="disabled" value="<cfif (modoDet EQ "CAMBIO")>#LSCurrencyFormat((rsLinea.DOcantidad*rsLinea.DOpreciou)-rsLinea.DOmontodesc,'none')#<cfelse>0.0000</cfif>" size="18" maxlength="18">
	</td>
  </tr>
  <tr>
	    <td align="right" nowrap><strong>#t.Translate('LB_CentroFuncional','Centro Funional')#:&nbsp;</strong></td>
	    <td>
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="1%">
						<input type="text" name="CFcodigo" id="CFcodigo" tabindex="3"
                        value="<cfif rsDcontrato.CPDEid EQ '-1' and rsDcontrato.CMtipo EQ 'C'>
								<cfelse>
                                    <cfif (mododet EQ 'CAMBIO')>
										#rsLinea.CFcodigo#
                               <cfelse>
										#trim(rsDcontrato.CFcodigo)#
									</cfif>
                               </cfif>"
						<cfif rsDcontrato.CPDEid NEQ "-1" and rsDcontrato.CMtipo EQ "C"> readonly </cfif>
                        onBlur="javascript: TraeCFuncional(this); " size="10" maxlength="10" onFocus="javascript:this.select();">
						<input type="hidden" name="CFid"
                        value="<cfif rsDcontrato.CPDEid EQ '-1' and rsDcontrato.CMtipo EQ 'C'>
								<cfelse>
	                                <cfif (mododet EQ 'CAMBIO')>
										#rsLinea.CFid#
                                <cfelse>
								    	#rsDcontrato.CFid#
	                               	</cfif>
                                </cfif>"
					</td>
					<td nowrap>
						<input type="text" name="CFdescripcion" id="CFdescripcion" tabindex="3" disabled value="<cfif (mododet EQ "CAMBIO")>#rsLinea.CFdescripcion#</cfif>"
							size="40"
							maxlength="80">
                    <cfif rsDcontrato.CPDEid NEQ "-1" and rsDcontrato.CMtipo EQ "C">
                    <cfelse>
						<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Centros Funcionales" name="CFimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCFuncional();'></a></td>
                    </cfif>
			</table>
			<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="display:none" ></iframe>
			<iframe name="frTotal" id="frTotal" marginheight="0" marginwidth="0" height="0" frameborder="1" width="0" scrolling="auto" src=""  style="display:none" ></iframe>
		</td>
		<td></td>
		<td colspan="2" align="right"><b>#t.Translate('LB_SaldoDetalleContrato','Saldo Detalle Contrato')#:&nbsp;</b></td>
		<td>
			<input name="DOCmontoTotal"  type="text" tabindex="-1" class="cajasinbordeb" readonly value="#LSCurrencyFormat(rsClas.SaldoTotal)#" size="18" maxlength="18">
		</td>
  </tr>
<!---Obtiene la lista de distribuciones disponibles--->
	<cfquery name="rsDistribuciones" datasource="#session.DSN#">
		select CPDCid, <cf_dbfunction name="concat" args="rtrim(CPDCcodigo),' - ',CPDCdescripcion"> as Descripcion
	  	from CPDistribucionCostos
		where Ecodigo=#session.Ecodigo#
	   	and CPDCactivo=1
	   	and Validada = 1
	   	<cfif rsDcontrato.CPDCid NEQ "" >
			and CPDCid = #rsDcontrato.CPDCid#
		</cfif>
	</cfquery>

	<!---Obtiene la distribucion aplicada en la linea de la orden de compra--->
	<cfif isdefined("form.DOlinea") and len(trim(form.DOlinea))>
		<cfquery name="rsDistribucionElegida" datasource="#session.DSN#">
			select CPDCid
	  		from DOrdenCM
			where DOlinea   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DOlinea#">
			and EOidorden   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		</cfquery>
	</cfif>

	<!---Obtiene la descripcion de la distribucion aplicada en la linea de la orden de compra--->
	<cfif isdefined("rsDistribucionElegida.CPDCid") and len(trim(rsDistribucionElegida.CPDCid))>
		<cfquery name="rsDescripcionDistribucionElegida" datasource="#session.DSN#">
			select <cf_dbfunction name="concat" args="rtrim(CPDCcodigo),' - ',CPDCdescripcion"> as Descripcion
	  		from CPDistribucionCostos
			where CPDCid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDistribucionElegida.CPDCid#">
		</cfquery>
	</cfif>

	<!---Sirve para saber si viene de una solicitud de compra--->
	<cfif isdefined("form.DOlinea") and len(trim(form.DOlinea))>
		<cfquery name="valLinea" datasource="#session.DSN#">
			select ESidsolicitud
	  		from DOrdenCM
			where DOlinea   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DOlinea#">
			and EOidorden   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		</cfquery>
	</cfif>
  <tr>
	    <td align="right"><strong>#t.Translate('LB_Pais','Pa&iacute;s')#: &nbsp;</strong></td>
	    <td><select name="Ppais">
	      <cfloop query="rsPais">
	        <option value="#rsPais.Ppais#" <cfif modoDet neq 'ALTA' and trim(rsPais.Ppais) eq trim(rsLinea.Ppais) >selected<cfelseif trim(rsPais.Ppais) eq trim(rsPaisSocio.Ppais) >selected</cfif> >#HTMLEditFormat(rsPais.Pnombre, -1)#</option>
	      </cfloop>
	    </select>
	    </td>
	    <td align="right" nowrap><strong id="EtiquetaDistribucion"
			<cfif modoDet EQ "CAMBIO"><cfif rsLinea.CMtipo EQ "A">style="display:"<cfelse>style="display:none"</cfif></cfif>>
			Distribucion del monto:</strong></td>
		<td><input type="checkbox" name="CheckDistribucion" id="CheckDistribucion"
				<cfif rsDcontrato.CPDCid EQ "" >unchecked<cfelse>Checked</cfif>
				disabled
		</td>
		<input type="hidden" id="CheckDistribucionHidden" name="CheckDistribucionHidden"
			<cfif rsDcontrato.CPDCid NEQ "">value="1"<cfelse>value="0"</cfif>>

  </tr>
	<tr>
		<td></td>
		<td></td>
		<cfif rsDcontrato.CPDCid NEQ "" >
		<td align="right" nowrap><strong id="EtiquetaPlantilla">#t.Translate('LB_Distribucion','Distribuci&oacute;n')#:&nbsp;</strong></td>
		<td width="1%">

		<select name="PlantillaDistribucion" id="PlantillaDistribucion" >

			<cfloop query="rsDistribuciones">
				<option value="#rsDistribuciones.CPDCid#" <cfif (#rsDistribuciones.CPDCid# eq #rsDcontrato.CPDCid#)>selected</cfif>>#rsDistribuciones.Descripcion#</option>
			</cfloop>
		</select>
		</td>
		</cfif>
	</tr>

  <tr><td><br></td></tr>



	<SCRIPT LANGUAGE="JavaScript">

    <cfif rsDcontrato.CMtipo EQ "C" and rsDcontrato.CPDCid EQ "">
        TraeCFuncional(document.getElementById("CFcodigo"));
    </cfif>

		function traeValor(elemento){
			var posicion=document.getElementById(elemento).options.selectedIndex; //posicion
			var valor=document.getElementById(elemento).options[posicion].text; //valor
			return valor;
			}
		function cambioDeEstado(){
			if(objForm.CheckDistribucion.checked){
				objForm.CheckDistribucion.checked = false;
				if(document.getElementById('CheckDistribucionHidden').value == 1){
				document.getElementById('CheckDistribucionHidden').value = 0;}
				else{document.getElementById('CheckDistribucionHidden').value = 1;}}
			else{
				objForm.CheckDistribucion.checked = true;
				if(document.getElementById('CheckDistribucionHidden').value == 1){
				document.getElementById('CheckDistribucionHidden').value = 0;}
				else{document.getElementById('CheckDistribucionHidden').value = 1;}}
			}
		function habilitaCheck(){
			var valor = traeValor('CMtipo');
			if(valor == "Artículo"){
				document.getElementById('CheckDistribucion').style.display = "";
				document.getElementById('EtiquetaDistribucion').style.display = "";}
			else{
				document.getElementById('CheckDistribucion').style.display = "none";
				document.getElementById('EtiquetaDistribucion').style.display = "none";}
			}
		function habilitaPlantilla(){
			var valor = traeValor('CMtipo');
			var checkActivo = (document.getElementById('CheckDistribucion').checked);
			if(valor == "Artículo" && checkActivo){
				document.getElementById('EtiquetaPlantilla').style.display = "";
				document.getElementById('PlantillaDistribucion').style.display = "";}
			else{
				document.getElementById('EtiquetaPlantilla').style.display = "none";
				document.getElementById('PlantillaDistribucion').style.display = "none";}
			}
	</SCRIPT>
<!---JMRV. Fin. Check de Distribucion para Articulos. 02/05/2014 --->

    <td align="right">
		<cfif rsActividad.Pvalor eq 'S'>
            <strong><strong>Act.Empresarial</strong>:</strong>&nbsp;
        </cfif>
    </td>
    <td>
   	   	<cfif rsActividad.Pvalor eq 'S'>
			<cfif mododet EQ 'CAMBIO' and len(rtrim(rsLinea.recordcount)) gt 0 and isdefined('rsLinea.FPAEid')and len(rtrim(rsLinea.FPAEid)) gt 0 >
                <cf_ActividadEmpresa idActividad="#rsLinea.FPAEid#" valores="#rsLinea.CFComplemento#" readonly="#rsFormularPor.Pvalor#" etiqueta="" Ecodigo="#lvarFiltroEcodigo#">
            <cfelse>
                <cf_ActividadEmpresa etiqueta="" Ecodigo="#lvarFiltroEcodigo#">
            </cfif>
	   </cfif>
	</td>

    <td colspan="2" rowspan="2">
		<cfif isdefined('rsCPDD') or isdefined('rsSC')>
                <table border="0" cellspacing="0" cellpadding="0" align="center" width="100%" style="border:solid 1px ##CCCCCC">
                    <tr>
                        <td align="right" width="75%" valign="top" style="background-color:##E9E9E9">
                        	<strong><cfif isdefined('rsCPDD')>Suficiencia<cfelse>Solic.Compra</cfif> Num:</strong>&nbsp;
                        </td>
                        <td align="right" nowrap>
                            <input 	type="text" size="20" style="text-align:right;border:none;background-color:##E9E9E9" name="CPDEnumeroDocumento" id="CPDEnumeroDocumento" disabled="disabled"
                                    value="<cfif isdefined('rsCPDD')> #trim(rsCPDD.CPDEnumeroDocumento)# <cfelse> #rsSC.ESnumero#</cfif>"
                             >
                        </td>
                    </tr>
                    <tr>
                        <td align="right" width="75%" valign="top" style="background-color:##E9E9E9">
                        	<strong>Monto:</strong>&nbsp;
                        </td>
                        <td align="right" nowrap>
                            <input 	type="text" size="20" style="text-align:right;border:none;background-color:##E9E9E9"  name="CPDDsaldo" id="CPDDsaldo" disabled="disabled"
		                            value="<cfif isdefined('rsCPDD')> #numberFormat(rsCPDD.CPDDsaldo/rsOrden.EOtc,",9.99")# <cfelse> #numberFormat(rsSC.DStotallinest,",9.99")#</cfif>"
                            >
                        </td>
                    </tr>
                </table>
        </cfif>
	</td>
  </tr>
    <cfif mododet EQ "CAMBIO" and rsLinea.EOestado EQ 5 and rsModificaOC.value EQ 0>
		<input  type="hidden" name="EOestado" value="#rsLinea.EOestado#">
  </cfif>
</table>

    <input name="DOobservaciones" type="hidden" value="<cfif (modoDet EQ "CAMBIO")>#rsLinea.DOobservaciones#</cfif>">
    <input name="DOalterna" type="hidden" value="<cfif (modoDet EQ "CAMBIO")>#rsLinea.DOalterna#</cfif>">
    <input type="hidden" name="ts_rversionD" value="<cfif (modoDet EQ "CAMBIO")>#tsD#</cfif>">
    <input name="DOlinea" type="hidden" value="<cfif (modoDet EQ "CAMBIO")>#rsLinea.DOlinea#</cfif>">
</cfoutput>
<cfsavecontent variable="qformsNombresCamposDetalle">
<cfoutput>
	objForm.CMtipo.description = "#JSStringFormat('Item')#";
	objForm.Almacen.description = "#JSStringFormat('Almacén')#";
	objForm.Aid.description = "#JSStringFormat('Artículo')#";
	//objForm.Cid.description = "#JSStringFormat('Concepto')#";
	//objForm.ACcodigo.description = "#JSStringFormat('Categoría')#";
	//objForm.ACid.description = "#JSStringFormat('Clase')#";
	objForm.DOdescripcion.description = "#JSStringFormat('Descripción')#";
	objForm.CFid.description = "#JSStringFormat('Centro Funcional')#";
	objForm.DOgarantia.description = "#JSStringFormat('Garantía')#";
	objForm.DOfechaes.description = "#JSStringFormat('Fecha estimada de entrega')#";
	objForm.DOcantidad.description = "#JSStringFormat('Cantidad')#";
	objForm.DOpreciou.description = "#JSStringFormat('Precio Unitario')#";
	objForm.Ucodigo.description = "#JSStringFormat('Unidad')#";
	objForm.Icodigo.description = "#JSStringFormat('Impuesto')#";
</cfoutput>
</cfsavecontent>
<cfoutput></cfoutput>
<cfsavecontent variable="qformsHabilitarValidacionDetalle">
	if (objForm.botonSel.getValue()=="Alta"||objForm.botonSel.getValue()=="Cambio"){
		objForm.CMtipo.required = true;
		if (objForm.CMtipo.getValue()=="A"){
			objForm.Almacen.required = true;
			objForm.Aid.required = true;
			//objForm.Cid.required = false;
			//objForm.ACcodigo.required = false;
			//objForm.ACid.required = false;
		}else if (objForm.CMtipo.getValue()=="S"){
			objForm.Almacen.required = false;
			objForm.Aid.required = false;
			//objForm.Cid.required = true;
			//objForm.ACcodigo.required = false;
			//objForm.ACid.required = false;

		}else if (objForm.CMtipo.getValue()=="F"){
			objForm.Almacen.required = false;
			objForm.Aid.required = false;
			//objForm.Cid.required = false;
			//objForm.ACcodigo.required = true;
			//objForm.ACid.required = true;
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
		//objForm.Cid.required = false;
		//objForm.ACcodigo.required = false;
		//objForm.ACid.required = false;
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
	objForm.CMtipo.required = false;
	objForm.Almacen.required = false;
	objForm.Aid.required = false;
	//objForm.Cid.required = false;
	//objForm.ACcodigo.required = false;
	//objForm.ACid.required = false;
	objForm.DOdescripcion.required = false;
	objForm.CFid.required = false;
	objForm.DOgarantia.required = false;
	objForm.DOfechaes.required = false;
	objForm.DOcantidad.required = false;
	objForm.DOpreciou.required = false;
	objForm.Ucodigo.required = false;
	objForm.Icodigo.required = false;
</cfsavecontent>
<cfsavecontent variable="qformsFinalizarValidacionDetalle">
	objForm.DOcantidad.obj.value = qf(objForm.DOcantidad.obj.value);
	objForm.DOpreciou.obj.value = qf(objForm.DOpreciou.obj.value);
	objForm.CMtipo.obj.disabled = false;
	objForm.Ucodigo.obj.disabled = false;
	objForm.DOdescripcion.obj.disabled = false;

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

	<cfoutput>
	//evalua que no se pase el monto de la linea del monto original de la suficiencia
	function funcCambioDet(){
	<cfif isdefined('rsLinea.CPDDid') and len(trim(#rsLinea.CPDDid#)) gt 0>
		var totalPagar 	= qf(document.form1.DOpreciou.value) * qf(document.form1.DOcantidad.value);
		var descuento	= document.form1.DOmontodesc.value;
		var Suf			= #rsCPDD.CPDDsaldo#;
		//se divide el monto de la suficiencia entre el tipo de cambio para que esten las dos en la misma moneda
		var saldoSuf	= Suf/document.form1.EOtc.value;
		if((totalPagar-descuento)> saldoSuf ){
			alert('EL monto total de la linea no puede ser mayor al monto de la suficiencia');
			return false;
		}
	</cfif>
	return true;
	}
	</cfoutput>

	function MontoTotal(){
		var totalPagar 	= qf(document.form1.DOpreciou.value) * qf(document.form1.DOcantidad.value);
		var descuento	= qf(document.form1.DOmontodesc.value);
		document.form1.DOmontoTotal.value = totalPagar-descuento;
	}

	function calcular_totales(){
		var paramTotal = "?form=form1&EOidorden="+ document.form1.EOidorden.value + "&DOcantidad="+document.form1.DOcantidad.value + "&DOpreciou="+document.form1.DOpreciou.value + "&Icodigo=" + trim(document.form1.Icodigo.value) + "&EOdesc=<cfoutput>#rsMontoDesc.sumaDesc#</cfoutput>" + "&modo=<cfoutput>#mododet#</cfoutput>" + "&Ecodigo=<cfoutput>#lvarFiltroEcodigo#</cfoutput>";
		<cfif mododet neq 'ALTA'>
			paramTotal += "&DOlinea=" + document.form1.DOlinea.value;
		</cfif>
		document.getElementById("frTotal").src="/cfmx/sif/cm/operacion/orden-total.cfm" + paramTotal;
		MontoTotal();
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
					MontoTotal();
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
					MontoTotal();
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