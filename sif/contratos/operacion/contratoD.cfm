
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DetallesContrato" Default= "Detalles de Contrato" XmlFile="ContratoD.xml" returnvariable="LB_DetallesContrato"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Item" Default= "Item" XmlFile="ContratoD.xml" returnvariable="LB_Item"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Articulo" Default= "Art&iacute;culo" XmlFile="ContratoD.xml" returnvariable="LB_Articulo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Servicio" Default= "Servicio" XmlFile="ContratoD.xml" returnvariable="LB_Servicio"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Clasificacion" Default= "Clasificaci&oacute;n" XmlFile="ContratoD.xml" returnvariable="LB_Clasificacion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Activo" Default= "Activo" XmlFile="ContratoD.xml" returnvariable="LB_Activo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Obras" Default= "Obras" XmlFile="ContratoD.xml" returnvariable="LB_Obras"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Almacen" Default= "Almac&eacute;n:&nbsp;" XmlFile="ContratoD.xml" returnvariable="LB_Almacen"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Categoria" Default= "Categor&iacute;a:&nbsp;" XmlFile="ContratoD.xml" returnvariable="LB_Categoria"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CentroFuncional" Default= "Centro Funcional" XmlFile="ContratoD.xml" returnvariable="LB_CentroFuncional"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CuentaPresupuesto" Default= "Cuenta Presupuesto" XmlFile="ContratoD.xml" returnvariable="LB_CuentaPresupuesto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Montototal" Default= "Monto total" XmlFile="ContratoD.xml" returnvariable="LB_Montototal"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Suficiencia" Default= "Suficiencia Num" XmlFile="ContratoD.xml" returnvariable="LB_Suficiencia"/>


<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfif isdefined("url.CTDCont") and len(trim(url.CTDCont))><cfset form.CTDCont = url.CTDCont></cfif>
<cfparam name="mododet" default="ALTA">
<cfif not isdefined('lvarFiltroEcodigo') or len(trim(#lvarFiltroEcodigo#)) eq 0 >
  <cfset lvarFiltroEcodigo = #session.Ecodigo#>
</cfif>


<cfif isdefined("form.CTContid")>
	<cfset modo = 'CAMBIO'>
</cfif>


<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js">//</script>



<cfif isdefined("form.CTDCont") and len(trim(form.CTDCont))>
	<!--- Detalle de la Línea --->
	<cfquery name="rsLinea" datasource="#Session.DSN#">
				select a.CPDDid, a.ACcodigo, a.Ccodigo, a.CMtipo, a.Alm_Aid,a.Cid, c.CFcodigo,c.CFid,c.CFdescripcion, cp.CPcuenta, cp.CPformato, cp.CPdescripcion,
                a.CTDCmontoTotalOri,a.CTDCont, g.Ccodigo as id, g.Cdescripcion,a.ts_rversion,h.Ccodigoclas, h.Cdescripcion,h.Cnivel,h.Ccodigo,i.ACcodigo, b.CTtipoCambio,a.CPDEid
		from CTDetContrato a
			inner join CTContrato b
            	on a.CTContid = b.CTContid
                and a.Ecodigo = b.Ecodigo
			left outer join CFuncional c
				on c.Ecodigo = a.Ecodigo and c.CFid = a.CFid
             left outer join CPresupuesto cp
             	on a.CPcuenta = cp.CPcuenta
			left outer join Almacen e
				on e.Aid = a.Alm_Aid
			left outer join Articulos f
				on f.Aid = a.Aid
            left outer join Clasificaciones h
            	on a.Ccodigo = h.Ccodigo
                and a.Ecodigo = h.Ecodigo
			left outer join Conceptos g
				on g.Cid = a.Cid
            left outer join AClasificacion i
            	on a.ACcodigo = i.ACcodigo
		where a.Ecodigo = #lvarFiltroEcodigo#
		  and a.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTContid#">
		  and a.CTDCont   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTDCont#">
	</cfquery>
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp"
		artimestamp="#rsLinea.ts_rversion#"
		returnvariable="tsD">
	</cfinvoke>
	<cfif rsLinea.RecordCount>
        <cfset mododet = "CAMBIO">
    </cfif>
</cfif>

<cfif isdefined("rsLinea.CPDEid") and len(trim(#rsLinea.CPDEid#)) gt 0>
	<cfquery name="rsCPDD" datasource="#session.DSN#">
		select e.CPDEnumeroDocumento, d.CPDDsaldo
        from CPDocumentoE e
            inner join CPDocumentoD d
            	on d.CPDEid = e.CPDEid
		where d.Ecodigo = #lvarFiltroEcodigo#
			and d.CPDEid = #rsLinea.CPDEid#
	</cfquery>
</cfif>


<!--- Items permitidos coprar al comprador, si no hay ninguno marcado implica que no hay ninguna restricción, por tantose dará permiso para todo--->
<cfquery name="rsItems" datasource="#Session.DSN#">
	select CTCarticulo, CTCservicio,CTCactivofijo,CTCobra,CTCid
	from CTCompradores
	where Ecodigo = #session.Ecodigo#
	and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
</cfquery>

<cfquery name="rsCategorias" datasource="#session.DSN#" >
	select ACcodigo, ACdescripcion
	from ACategoria
	where Ecodigo = #lvarFiltroEcodigo#
</cfquery>
<!--- Clasificacion Activos--->
<cfif isdefined("rsLinea.ACcodigo")>
<cfquery name="rsClasificacion" datasource="#Session.DSN#">
	select ACid, ACdescripcion, ACcodigo
	from AClasificacion
	where Ecodigo = #lvarFiltroEcodigo#
    and ACcodigo = '#rsLinea.ACcodigo#'
	order by ACcodigo, ACdescripcion
</cfquery>
</cfif>

<cfif isdefined("rsLinea.Ccodigo")>
<!--- Clasificacion de Articulos --->
<cfquery name="rsClasificaciones" datasource="#Session.DSN#">
	select Ccodigoclas, Cdescripcion,Ccodigo,Cnivel as Nnivel
	from Clasificaciones
	where Ecodigo = #lvarFiltroEcodigo#
    and Ccodigo = '#rsLinea.Ccodigo#'
	order by Ccodigoclas, Cdescripcion
</cfquery>
</cfif>


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
		f.Descripcion.value="";

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
			f.Descripcion.disabled = true;
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
			f.Descripcion.disabled = true;
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
			f.Descripcion.disabled = false;
		}
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

<input type="hidden" name="CTCid"
	value="<cfif isdefined("rsItems") and len(trim(rsItems.CTCid))>#rsItems.CTCid#</cfif>">


<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td nowrap class="subTitulo"><font size="2">#LB_DetallesContrato#</font></td>
  </tr>
</table>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="21%" align="right"><strong>#LB_Item#:</strong></td>
    <td colspan="3">
      <table width="100%">
        <tr>
          <td nowrap>
            <select name="CMtipo" id="CMtipo" onChange="javascript:limpiarDetalle();cambiarDetalle();" tabindex="2"
          disabled >



              <cfif (rsItems.CTCarticulo eq 1) and modoDet EQ "ALTA">
                <option value="A" <cfif (modoDet EQ "CAMBIO") and rsLinea.CMtipo EQ "A">selected</cfif>>#LB_Articulo#</option>
               <cfelseif modoDet EQ "CAMBIO" >
			     <option value="A" <cfif (modoDet EQ "CAMBIO") and rsLinea.CMtipo EQ "A">selected</cfif>>#LB_Articulo#</option>
			   </cfif>
                <cfif (rsItems.CTCarticulo eq 1) and modoDet EQ "ALTA">
                <option value="C" <cfif (modoDet EQ "CAMBIO") and rsLinea.CMtipo EQ "C">selected</cfif>>#LB_Articulo#</option>
               <cfelseif modoDet EQ "CAMBIO" >
			     <option value="C" <cfif (modoDet EQ "CAMBIO") and rsLinea.CMtipo EQ "C">selected</cfif>>#LB_Articulo#</option>
			   </cfif>

               <cfif (rsItems.CTCservicio EQ 1) and modoDet EQ "ALTA">
                 <option value="S" <cfif (modoDet EQ "CAMBIO") and rsLinea.CMtipo EQ "S">selected</cfif>>#LB_Servicio#</option>
               <cfelseif modoDet EQ "CAMBIO">
			     <option value="S" <cfif (modoDet EQ "CAMBIO") and rsLinea.CMtipo EQ "S">selected</cfif>>#LB_Servicio#</option>
			   </cfif>
                <cfif (rsItems.CTCservicio EQ 1) and isdefined('rsLinea.Ccodigo') and rsLinea.Ccodigo neq "" >
			     <option value="C" <cfif (modoDet EQ "CAMBIO") and rsLinea.CMtipo EQ "S">selected</cfif>>#LB_Clasificacion#</option>
			   </cfif>

               <cfif (rsItems.CTCactivofijo eq 1) and modoDet EQ "ALTA">
                 <option value="F" <cfif (modoDet EQ "CAMBIO") and rsLinea.CMtipo EQ "F">selected</cfif>>#LB_Activo#</option>
               <cfelseif modoDet EQ "CAMBIO">
			     <option value="F" <cfif (modoDet EQ "CAMBIO") and rsLinea.CMtipo EQ "F">selected</cfif>>#LB_Activo#</option>
			   </cfif>
			   <cfif (rsItems.CTCobra eq 1) and modoDet EQ "ALTA">
                 <option value="P" <cfif (modoDet EQ "CAMBIO") and rsLinea.CMtipo EQ "P">selected</cfif>>#LB_Obras#</option>
               <cfelseif modoDet EQ "CAMBIO">
			     <option value="P" <cfif (modoDet EQ "CAMBIO") and rsLinea.CMtipo EQ "P">selected</cfif>>#LB_Obras#</option>
			   </cfif>
            </select>


          </td>
          <td width="1%" align="right" nowrap>
            <div id="EtiAlmacen"  <cfif isdefined ("rsLinea.CMtipo")  and rsLinea.CMtipo EQ "A">style="display:"<cfelse>style="display:none"</cfif>><strong>#LB_Almacen#</strong></div>
            <div id="EtiActivo" <cfif isdefined("rsLinea.CMtipo")  and rsLinea.CMtipo EQ "F">style="display:"<cfelse>style="display:none"</cfif> ><strong>#LB_Categoria#</strong></div></td>
          <td width="45%" nowrap>
            <div id="divAlmacen" <cfif isdefined('rsLinea.CMtipo') and rsLinea.CMtipo EQ "A">style="display:"<cfelse>style="display:none"</cfif>>
              <cfif mododet neq 'ALTA'>


               		 <cf_sifalmacen id="#rsLinea.Alm_Aid#"  size="15" aid="Almacen" Ecodigo="#lvarFiltroEcodigo#">
                <cfelse>
                <cf_sifalmacen size="15" aid="Almacen" Ecodigo="#lvarFiltroEcodigo#">
              </cfif>
            </div>
            <div id="divActivo" <cfif isdefined('rsLinea.CMtipo') and rsLinea.CMtipo EQ "F">style="display:"<cfelse>style="display:none"</cfif>>
              <select name="ACcodigo" onChange="javascript:cambiar_categoria();" tabindex="2" >

                <cfloop query="rsCategorias">
                  <cfif mododet EQ 'ALTA'>
                    <option value="#rsCategorias.ACcodigo#">#rsCategorias.ACdescripcion#</option>
                    <cfelse>
                    <option value="#rsCategorias.ACcodigo#" <cfif rsLinea.ACcodigo EQ rsCategorias.ACcodigo>selected</cfif> >#rsCategorias.ACdescripcion#</option>
                  </cfif>
                </cfloop>
              </select>
          </div></td>
          <!--- Articulo, clasificacion y servicio --->
          <td align="right" width="1%" valign="middle" nowrap>
            <div id="EtiArticulo"
			<cfif isdefined('rsLinea.CMtipo') and rsLinea.CMtipo EQ "A">style="display:"<cfelse>style="display:none"</cfif>><strong>#LB_Articulo#:&nbsp;</strong></div>
            <div id="EtiClasificacion"
			<cfif isdefined('rsLinea.CMtipo') and ((rsLinea.CMtipo EQ "F" or rsLinea.CMtipo EQ "C") or (rsLinea.CMtipo EQ "S" and rsLinea.Ccodigo NEQ ""))>
            style="display:"<cfelse>style="display:none"</cfif> ><strong>#LB_Clasificacion#:&nbsp;</strong></div>

            <div id="EtiConcepto" <cfif isdefined('rsLinea.CMtipo') and rsLinea.CMtipo EQ "S"  and rsLinea.Cid NEQ "">style="display:"<cfelse>style="display:none"</cfif>  ><strong>#LB_Servicio#:&nbsp;</strong></div></td>
          <td nowrap>
            <div id="divConcepto" <cfif isdefined('rsLinea.CMtipo') and rsLinea.CMtipo EQ "S" and rsLinea.Cid NEQ "" >style="display:"<cfelse>style="display:none"</cfif> >
              <cfif mododet neq 'ALTA'>
               		 <cf_sifconceptos query="#rsLinea#" name= "id" desc="Cdescripcion" tabindex="2" readOnly="yes" Ecodigo="#lvarFiltroEcodigo#">

                <cfelse>
                <cf_sifconceptos desc="Cdescripcion" tabindex="2" Ecodigo="#lvarFiltroEcodigo#">
              </cfif>
            </div>
            <div id="divArticulo" <cfif isdefined('rsLinea.CMtipo') and rsLinea.CMtipo EQ "A">style="display:"<cfelse>style="display:none"</cfif>>
			  <cfif mododet neq 'ALTA'>
              	<cfif rsLinea.CMtipo eq 'A'>
              	  <cfif rsModificaOC.value NEQ 0 and rsLinea.EOestado EQ 5>
                	<cf_sifarticulos form="form1" id="Aid" almacen="Almacen" query="#rsLinea#" tabindex="2" readOnly="yes">
                  <cfelse>
                	<cf_sifarticulos form="form1" id="Aid" almacen="Almacen" query="#rsLinea#" tabindex="2">
                  </cfif>
                <cfelse>
                  	<input type="hidden" name="Aid" value="-1">
                </cfif>
              <cfelse>
                <cf_sifarticulos form="form1" id="Aid" almacen="Almacen" Ecodigo="#lvarFiltroEcodigo#" tabindex="2">
              </cfif>
            </div>

            <div id="divArticulo" <cfif isdefined('rsLinea.CMtipo') and (rsLinea.CMtipo EQ "C" or rsLinea.CMtipo EQ "S") and rsLinea.Ccodigo neq "">
            	style="display:"<cfelse>style="display:none"</cfif>>

            		<cfif modo neq 'ALTA' and isdefined("rsClasificaciones") and( rsLinea.CMtipo EQ "S" or rsLinea.CMtipo EQ "F" or rsLinea.CMtipo EQ "C")>
							<cf_sifclasificacionarticulo tabindex="1" query="#rsClasificaciones#" desc="Cdescripcion" id="Ccodigo" readOnly="yes">

					</cfif>
             </div>

            <div id="divClasificacion" <cfif isdefined('rsLinea.CMtipo') and rsLinea.CMtipo EQ "F" >style="display:"<cfelse>style="display:none"</cfif>>
            <cfif (modo NEQ "ALTA") and isdefined("rsClasificacion")>
                 <select name="ACid">
                     <cfloop query="rsClasificacion">
                          <cfif mododet NEQ 'ALTA'>

                            <option value="#rsClasificacion.ACid#">#rsClasificacion.ACdescripcion#</option>
                            <cfelse>
                            <option value="#rsCategorias.ACcodigo#" <cfif rsLinea.ACcodigo EQ rsCategorias.ACcodigo>selected</cfif> >#rsCategorias.ACdescripcion#</option>
                          </cfif>
                      </cfloop>
                 </select>
             </cfif>



          </div></td>
        </tr>
    </table></td>
    <td width="12%" align="right">&nbsp;</td>
    <td width="12%" align="left">&nbsp;</td>
  </tr>


  <tr>
    <td align="right" nowrap><strong>#LB_CentroFuncional#:</strong></td>
    <td>
		<table border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="1%">
					<input type="text" name="CFcodigo" id="CFcodigo" tabindex="3" value="<cfif (mododet EQ "CAMBIO")>#rsLinea.CFcodigo#</cfif>" onBlur="javascript: TraeCFuncional(this); " size="10" maxlength="10" disabled="disabled" onFocus="javascript:this.select();">
					<input type="hidden" name="CFid" value="<cfif (mododet EQ "CAMBIO")>#rsLinea.CFid#</cfif>">
				</td>
				<td nowrap>
					<input type="text" name="CFdescripcion" disabled="disabled" id="CFdescripcion" tabindex="3" disabled value="<cfif (mododet EQ "CAMBIO")>#rsLinea.CFdescripcion#</cfif>"
						size="40"
						maxlength="80">
					</td>
		</table>
		<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="display:none" ></iframe>
		<iframe name="frTotal" id="frTotal" marginheight="0" marginwidth="0" height="0" frameborder="1" width="0" scrolling="auto" src=""  style="display:none" ></iframe>
	</td>
	<td>
    </td>
    <td>
    </td>

	</tr>
	<tr></tr>


	<tr>

				    <td align="right" id="lblCuenta"><strong>#LB_CuentaPresupuesto#:</strong></td>
				    <td  id="tdCuenta"  nowrap="nowrap" colspan="4">

						<input type="hidden" name="CPcuenta" value="<cfif modoDet EQ 'CAMBIO'>#rsLinea.CPcuenta#</cfif>">
						<input type="text" name="CPformato" style="width:240px;" value="<cfif modoDet EQ 'CAMBIO'>#rsLinea.CPformato#</cfif>" readonly>
						<input type="text" name="CPdescripcion" size="50" value="<cfif modoDet EQ 'CAMBIO'>#rsLinea.CPdescripcion#</cfif>" readonly style="border:solid 1px ##CCCCCC" tabindex="-1">

					</td>
                                    
     <td align="right"><strong>#LB_Montototal#:</strong>&nbsp;</td>
    <td>
    
		<input name="CTDCmontoTotal"  onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);" onSubmit="javascript: return valida();" type="text" tabindex="4" style="text-align:right" <cfif isdefined('rsLinea.CPDEid') and rsLinea.CPDEid EQ -1>readonly="readonly"</cfif> value="<cfif (modoDet EQ "CAMBIO")>#numberformat(rsLinea.CTDCmontoTotalOri,9.99)#<cfelse>0.00</cfif>" size="18" maxlength="18">
    
	</td>
	</tr>
	<tr><td><br></td></tr>

	<SCRIPT LANGUAGE="JavaScript">
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

		function valida(){
		  document.form1.CTDCmontoTotal.value = qf(document.form1.CTDCmontoTotal.value);
		  return true;
		 }
	</SCRIPT>


    <td align="right">&nbsp;</td>
    <td>&nbsp;</td>

    <td colspan="2" rowspan="2">
		<cfif isdefined('rsCPDD') or isdefined('rsSC')>
                <table border="0" cellspacing="0" cellpadding="0" align="center" width="100%" style="border:solid 1px ##CCCCCC">
                    <tr>
                        <td align="right" width="75%" valign="top" style="background-color:##E9E9E9">
                        	<strong>#LB_Suficiencia#:</strong>&nbsp;
                        </td>
                        <td align="right" nowrap>
                            <input 	type="text" size="30" style="text-align:right;border:none;background-color:##E9E9E9" name="CPDEnumeroDocumento" id="CPDEnumeroDocumento" disabled="disabled"
                                    value="<cfif isdefined('rsCPDD') and  (isdefined('rsLinea.CPDEid')and rsLinea.CPDEid NEQ -1)> #trim(rsCPDD.CPDEnumeroDocumento)# 
									<cfelseif (isdefined('rsLinea.CPDEid') and rsLinea.CPDEid EQ -1)> Agrupación de Suficiencias<cfelse> #rsSC.ESnumero#</cfif>"
                             >
                        </td>
                    </tr>

                </table>
        </cfif>
	</td>
  </tr>
  <tr>
    <td align="right">&nbsp;</td>
    <td>&nbsp;</td>

  </tr>

</table>

    <input type="hidden" name="ts_rversion" value="<cfif (modoDet EQ "CAMBIO")>#tsD#</cfif>">
    <input name="CTDCont" type="hidden" value="<cfif (modoDet EQ "CAMBIO")>#rsLinea.CTDCont#</cfif>">
</cfoutput>
<cfsavecontent variable="qformsNombresCamposDetalle">
<cfoutput>
	objForm.CMtipo.description = "#JSStringFormat('Item')#";
	objForm.Almacen.description = "#JSStringFormat('Almacén')#";
	objForm.Aid.description = "#JSStringFormat('Artículo')#";
	objForm.Cid.description = "#JSStringFormat('Concepto')#";
	objForm.ACcodigo.description = "#JSStringFormat('Categoría')#";
	objForm.ACid.description = "#JSStringFormat('Clase')#";
	objForm.Descripcion.description = "#JSStringFormat('Descripción')#";
	objForm.CFid.description = "#JSStringFormat('Centro Funcional')#";

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
		objForm.Descripcion.required = true;
		objForm.CFid.required = true;

	}
	else
	{
		objForm.CMtipo.required = false;
		objForm.Almacen.required = false;
		objForm.Aid.required = false;
		objForm.Cid.required = false;
		objForm.ACcodigo.required = false;
		objForm.ACid.required = false;
		objForm.Descripcion.required = false;
		objForm.CFid.required = false;

	}
</cfsavecontent>
<cfsavecontent variable="qformsDesHabilitarValidacionDetalle">
	objForm.CMtipo.required = false;
	objForm.Almacen.required = false;
	objForm.Aid.required = false;
	objForm.Cid.required = false;
	objForm.ACcodigo.required = false;
	objForm.ACid.required = false;
	objForm.Descripcion.required = false;
	objForm.CFid.required = false;

</cfsavecontent>
<cfsavecontent variable="qformsFinalizarValidacionDetalle">
	objForm.DOcantidad.obj.value = qf(objForm.DOcantidad.obj.value);
	objForm.DOpreciou.obj.value = qf(objForm.DOpreciou.obj.value);
	objForm.CMtipo.obj.disabled = false;
	objForm.Ucodigo.obj.disabled = false;
	objForm.Descripcion.obj.disabled = false;
</cfsavecontent>
<cfsavecontent variable="qformsFocusOnDetalle">
	cambiarDetalle();
	cambiar_categoria();
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

