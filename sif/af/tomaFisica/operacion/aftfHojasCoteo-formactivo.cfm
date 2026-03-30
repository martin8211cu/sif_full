<!--- pintado de la forma de captura de un activo fijo para la hoja de conteo --->
<cf_dbfunction name="now" returnvariable="hoy">
<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>

<fieldset><legend><cfif (mododet NEQ "ALTA")>Modificar<cfelse>Agregar</cfif> Activo Fijo a Hoja de Conteo</legend>

<iframe frameborder="0" name="fr" height="0" width="0" style="visibility:hidden"></iframe>
<cfoutput>

<form action="aftfHojasCoteo-sql.cfm" method="post" name="formActivo" style="margin:0">
<input type="hidden" id="AFTFid_hoja" name="AFTFid_hoja" value="#Form.AFTFid_hoja#">
<cfif (mododet NEQ "ALTA")>
<input type="hidden" id="AFTFid_detallehoja" name="AFTFid_detallehoja" value="#Form.AFTFid_detallehoja#">
<input type="hidden" name="ts_rversion" value="#tsdet#" >
</cfif>
<cfinclude template="aftfHojasCoteo-hiddens.cfm">
<cfinclude template="aftfHojasCoteo-hiddenshoja.cfm">

<table width="100%" border="0" cellspacing="1" cellpadding="1" style="margin:0">
  <tr>
    <td width="10%" align="right" nowrap="nowrap"><strong>Activo&nbsp;:&nbsp;</strong></td>
    <td width="40%">
		<cfif (mododet NEQ "ALTA")>
			<cf_sifactivo form="formActivo" desc="Adescripcionx" query="#rsFormDet#" modificable="false">
		<cfelse>
			<cf_sifactivo form="formActivo" desc="Adescripcionx" funcion="getAidInfo" tabindex="1" craf=true>
		</cfif>
	</td>
    <td width="10%" align="right" nowrap="nowrap"><strong>Tipo&nbsp;:&nbsp;</strong></td>
    <td width="40%">
			<cfset ValuesArray=ArrayNew(1)>
			<cfif (mododet NEQ 'ALTA')>
              <cfset ArrayAppend(ValuesArray,rsFormDet.AFCcodigo)>
              <cfset ArrayAppend(ValuesArray,rsFormDet.AFCcodigoclas)>
              <cfset ArrayAppend(ValuesArray,rsFormDet.AFCdescripcion)>
            </cfif>
            <cf_conlis readonly="#(mododet NEQ 'ALTA')#" form="formActivo" objForm="objFormActivo" 
				Campos="AFCcodigo,AFCcodigoclas,AFCdescripcion"
				Desplegables="N,S,S"
				Modificables="N,S,N"
				Size="0,10,40"
				ValuesArray="#ValuesArray#"
				Title="Lista de Clasificaciones"
				Tabla="AFClasificaciones"
				Columnas="AFCcodigo,AFCcodigoclas,AFCdescripcion"
				Filtro="Ecodigo = #Session.Ecodigo# order by AFCcodigoclas,AFCdescripcion"
				Desplegar="AFCcodigoclas,AFCdescripcion"
				Etiquetas="Código,Descripción"
				filtrar_por="AFCcodigoclas,AFCdescripcion"
				Formatos="S,S"
				Align="left,left"
				Asignar="AFCcodigo,AFCcodigoclas,AFCdescripcion"
				Asignarformatos="I,S,S"
				tabindex="2"/>
	</td>
  </tr>
  <tr>
    <td width="10%" align="right" nowrap="nowrap"><strong>Descripción&nbsp;:&nbsp;</strong></td>
    <td width="40%">
		<input type="text" <cfif (mododet NEQ "ALTA")>value="#HTMLEditFormat(rsFormDet.Adescripcion)#"</cfif>
			<cfif (mododet NEQ 'ALTA')>
				tabindex="-1"
				readonly
				style="border:solid 1px ##CCCCCC; background:inherit;"
			<cfelse>
				tabindex="1"
				onFocus="javascript:this.select();"
			</cfif>
			id="Adescripcion" name="Adescripcion" size="60" maxlength="80">
	</td>
    <td width="10%" align="right" nowrap="nowrap"><strong>Serie&nbsp;:&nbsp;</strong></td>
    <td width="40%">
		<input type="text" <cfif (mododet NEQ "ALTA")>value="#HTMLEditFormat(rsFormDet.Aserie)#"</cfif>
			<cfif (mododet NEQ 'ALTA')>
				tabindex="-1"
				readonly
				style="border:solid 1px ##CCCCCC; background:inherit;"
			<cfelse>
				tabindex="2"
				onFocus="javascript:this.select();"
			</cfif>
			id="Aserie" name="Aserie" size="60" maxlength="50">
	</td>
  </tr>
  <tr>
    <td width="10%" align="right" nowrap="nowrap"><strong>Categoría&nbsp;:&nbsp;</strong></td>
    <td width="40%">
		<cfset ValuesArray=ArrayNew(1)>
		<cfif (mododet NEQ 'ALTA')>
			<cfset ArrayAppend(ValuesArray,rsFormDet.ACcodigo)>
			<cfset ArrayAppend(ValuesArray,rsFormDet.ACcodigodesc)>
			<cfset ArrayAppend(ValuesArray,rsFormDet.ACdescripcion)>
		</cfif>
		<cf_conlis readonly="#(mododet NEQ 'ALTA')#" form="formActivo" objForm="objFormActivo"  
			Campos="ACcodigo, ACcodigodesc, ACdescripcion"
			Desplegables="N,S,S"
			Modificables="N,S,N"
			Size="0,10,40"
			ValuesArray="#ValuesArray#"
			Title="Lista de Categorías"
			Tabla="ACategoria a"
			Columnas="ACcodigo, ACcodigodesc, ACdescripcion"
			Filtro="Ecodigo = #Session.Ecodigo# 
			order by ACcodigodesc, ACdescripcion"
			Desplegar="ACcodigodesc, ACdescripcion"
			Etiquetas="Código,Descripción"
			filtrar_por="ACcodigodesc, ACdescripcion"
			Formatos="S,S"
			Align="left,left"
			Asignar="ACcodigo, ACcodigodesc, ACdescripcion"
			Asignarformatos="I,S,S,S"
			funcion="resetClase"
			tabindex="1"/>
	</td>
    <td width="10%" align="right" nowrap="nowrap"><strong>C.Funcional&nbsp;:&nbsp;</strong></td>
    <td width="40%">
		<cfset ValuesArray = ArrayNew(1)>
		<cfif (mododet NEQ 'ALTA')>
			<cfset ArrayAppend(ValuesArray,rsFormDet.CFid)>
			<cfset ArrayAppend(ValuesArray,rsFormDet.CFcodigo)>
			<cfset ArrayAppend(ValuesArray,rsFormDet.CFdescripcion)>
		</cfif>
		<cf_conlis readonly="#(mododet NEQ 'ALTA')#" form="formActivo" objForm="objFormActivo"  
			campos="CFid,CFcodigo,CFdescripcion, CFpath, CFnivel" 
			ValuesArray = "#ValuesArray#"
			desplegables="N,S,S"
			modificables="N,S,N"
			size="0,10,40"
			title="Lista de Centros Funcionales"
			tabla="CFuncional"
			columnas="distinct CFid,CFcodigo,CFdescripcion,CFpath,CFnivel"
			filtro="CFuncional.Ecodigo = #session.Ecodigo# order by CFuncional.CFpath, CFuncional.CFcodigo, CFuncional.CFnivel"
			desplegar="CFcodigo,CFdescripcion"
			filtrar_por="CFuncional.CFcodigo,CFuncional.CFdescripcion"
			etiquetas="Código, Descripción"
			formatos="S,S"
			align="left,left"
			asignar="CFid,CFcodigo,CFdescripcion"
			asignarformatos="I,S,S"
			maxrowsquery="250"
			funcion="resetEmpleado" 
			tabindex="2">
	</td>
  </tr>
  <tr>
    <td width="10%" align="right" nowrap="nowrap"><strong>Clase&nbsp;:&nbsp;</strong></td>
    <td width="40%">
		<cfset ValuesArray=ArrayNew(1)>
		<cfif (mododet NEQ 'ALTA')>
		  <cfset ArrayAppend(ValuesArray,rsFormDet.ACid)>
		  <cfset ArrayAppend(ValuesArray,rsFormDet.ACcodigodesc_clas)>
		  <cfset ArrayAppend(ValuesArray,rsFormDet.ACdescripcion_clas)>
		</cfif>
		<cf_conlis readonly="#(mododet NEQ 'ALTA')#" form="formActivo" objForm="objFormActivo"  
			Campos="ACid, ACcodigodesc_clas, ACdescripcion_clas"
			Desplegables="N,S,S"
			Modificables="N,S,N"
			Size="0,10,40"
			ValuesArray="#ValuesArray#"
			Title="Lista de Clases"
			Tabla="AClasificacion a"
			Columnas="ACid, ACcodigodesc as ACcodigodesc_clas, ACdescripcion as ACdescripcion_clas, ACdescripcion as GATdescripcion"
			Filtro="Ecodigo = #Session.Ecodigo# 
			and ACcodigo = $ACcodigo,numeric$ 
			order by ACcodigodesc_clas, ACdescripcion_clas"
			Desplegar="ACcodigodesc_clas, ACdescripcion_clas"
			Etiquetas="Código,Descripción"
			filtrar_por="ACcodigodesc, ACdescripcion"
			Formatos="S,S"
			Align="left,left"
			Asignar="ACid, ACcodigodesc_clas,ACdescripcion_clas,GATdescripcion"
			Asignarformatos="I,S,S,S"
			debug="false"
			left="100"
			top="100"
			width="800"
			height="600"
			tabindex="1"/>
	</td>
    <td width="10%" align="right" nowrap="nowrap"><strong>Empleado&nbsp;:&nbsp;</strong></td>
    <td width="40%">
		<cfset ValuesArray=ArrayNew(1)>
		<cfif (mododet NEQ 'ALTA')>
			<cfset ArrayAppend(ValuesArray,rsFormDet.DEid)>
			<cfset ArrayAppend(ValuesArray,rsFormDet.DEidentificacion)>
			<cfset ArrayAppend(ValuesArray,rsFormDet.DEnombre)>
		</cfif>
		<cf_conlis readonly="#(mododet NEQ 'ALTA')#" form="formActivo" objForm="objFormActivo"  
			Campos="DEid,DEidentificacion,DEnombre"
			ValuesArray="#ValuesArray#"
			Desplegables="N,S,S"
			Modificables="N,S,N"
			Size="0,10,40"
			Title="Lista De Empleados"
			Tabla=" DatosEmpleado de"
			Columnas="de.DEid,de.DEidentificacion,
					{fn concat(de.DEapellido1,{fn concat(' ',{fn concat(de.DEapellido2,{fn concat(' ',de.DEnombre)})})})} as DEnombre"
			Filtro="de.Ecodigo = #session.Ecodigo# 
						and 
						( exists (
							select 1
							from EmpleadoCFuncional decf
							where decf.DEid = de.DEid
							and decf.CFid = $CFid,numeric$
							and #hoy# between decf.ECFdesde and decf.ECFhasta
						) or exists (
							select 1
							from LineaTiempo lt
								inner join RHPlazas rhp
								on rhp.RHPid = lt.RHPid
								and rhp.CFid = $CFid,numeric$
							where lt.DEid = de.DEid
							and #hoy# between lt.LTdesde and lt.LThasta
						) ) order by DEidentificacion"
			Desplegar="DEidentificacion,DEnombre"
			Etiquetas="Identificaci&oacute;n,Nombre"

			filtrar_por="de.DEidentificacion|{fn concat(de.DEapellido1,{fn concat(' ',{fn concat(de.DEapellido2,{fn concat(' ',de.DEnombre)})})})}"
			filtrar_por_delimiters="|"
			Formatos="S,S"
			Align="left,left"
			Asignar="DEid,DEidentificacion,DEnombre"
			Asignarformatos="S,S,S"
			MaxRowsQuery="200"
			tabindex="2"/>
	</td>
  </tr>
  <tr>
    <td width="10%" align="right" nowrap="nowrap"><strong>Marca&nbsp;:&nbsp;</strong></td>
    <td width="40%">
		<cfset ValuesArray=ArrayNew(1)>
		<cfif (mododet NEQ 'ALTA')>
		  <cfset ArrayAppend(ValuesArray,rsFormDet.AFMid)>
		  <cfset ArrayAppend(ValuesArray,rsFormDet.AFMcodigo)>
		  <cfset ArrayAppend(ValuesArray,rsFormDet.AFMdescripcion)>
		</cfif>
		<cf_conlis readonly="#(mododet NEQ 'ALTA')#" form="formActivo" objForm="objFormActivo"  
			Campos="AFMid,AFMcodigo,AFMdescripcion"
			Desplegables="N,S,S"
			Modificables="N,S,N"
			Size="0,10,40"
			ValuesArray="#ValuesArray#"
			Title="Lista de Marcas"
			Tabla="AFMarcas"
			Columnas="AFMid,AFMcodigo,AFMdescripcion"
			Filtro="Ecodigo = #Session.Ecodigo# order by AFMcodigo,AFMdescripcion"
			Desplegar="AFMcodigo,AFMdescripcion"
			Etiquetas="Código,Descripción"
			filtrar_por="AFMcodigo,AFMdescripcion"
			Formatos="S,S"
			Align="left,left"
			Asignar="AFMid,AFMcodigo,AFMdescripcion"
			Asignarformatos="I,S,S"
			funcion="resetModelo"
			tabindex="1"/>
	</td>
    <td width="10%" align="right" nowrap="nowrap"><strong>Vida &uacute;til&nbsp;:&nbsp;</strong></td>
    <td width="40%">
		<cfif (mododet NEQ 'ALTA')>
			<CF_inputNumber 
				query			= "#rsFormDet#"
				form			= "formActivo"
				name			= "Avutil"
				default		= "0"
				modificable	= "false"
				
				enteros			= "6"
				decimales		= "0"
				negativos		= "false"
				tabindex			="-1">
		<cfelse>
			<CF_inputNumber 
				form			= "formActivo"
				name			= "Avutil"
				default		= "0"
				
				enteros			= "6"
				decimales		= "0"
				negativos		= "false"
				tabindex			="2">
		</cfif>		
	</td>
  </tr>
  <tr>
    <td width="10%" align="right" nowrap="nowrap"><strong>Modelo&nbsp;:&nbsp;</strong></td>
    <td width="40%">
		<cfset ValuesArray=ArrayNew(1)>
		<cfif (mododet NEQ 'ALTA')>
		  <cfset ArrayAppend(ValuesArray,rsFormDet.AFMMid)>
		  <cfset ArrayAppend(ValuesArray,rsFormDet.AFMMcodigo)>
		  <cfset ArrayAppend(ValuesArray,rsFormDet.AFMMdescripcion)>
		</cfif>
		<cf_conlis readonly="#(mododet NEQ 'ALTA')#" form="formActivo" objForm="objFormActivo"  
			Campos="AFMMid,AFMMcodigo,AFMMdescripcion"
			Desplegables="N,S,S"
			Modificables="N,S,N"
			Size="0,10,40"
			ValuesArray="#ValuesArray#"
			Title="Lista de Modelos"
			Tabla="AFMModelos"
			Columnas="AFMMid,AFMMcodigo,AFMMdescripcion"
			Filtro="Ecodigo = #Session.Ecodigo# and AFMid = $AFMid,numeric$ order by AFMMcodigo,AFMMdescripcion"
			Desplegar="AFMMcodigo,AFMMdescripcion"
			Etiquetas="Código,Descripción"
			filtrar_por="AFMMcodigo,AFMMdescripcion"
			Formatos="S,S"
			Align="left,left"
			Asignar="AFMMid,AFMMcodigo,AFMMdescripcion"
			Asignarformatos="I,S,S"
			tabindex="1"/>
	</td>
    <td width="10%" align="right" nowrap="nowrap"><strong>Valor Rescate&nbsp;:&nbsp;</strong></td>
    <td width="40%">
		<cfif (mododet NEQ 'ALTA')>
			<CF_inputNumber 
				query			= "#rsFormDet#"
				form			= "formActivo"
				name			= "Avalrescate"
				default		= "0"
				modificable	= "false"
				
				enteros			= "9"
				decimales		= "2"
				negativos		= "false"
				tabindex			="-1">
		<cfelse>
			<CF_inputNumber 
				form			= "formActivo"
				name			= "Avalrescate"
				default		= "0"
				
				enteros			= "9"
				decimales		= "2"
				negativos		= "false"
				tabindex			="2">
		</cfif>	
	</td>
  </tr>
  <tr>
    <td width="10%" align="right" nowrap="nowrap" valign="top" rowspan="2"><strong>Observación&nbsp;:&nbsp;</strong></td>
    <td width="40%" rowspan="2">
		<textarea 
			tabindex="1"
			onFocus="javascript:this.select();"
			id="AFTFobservaciondetalle" 
			name="AFTFobservaciondetalle" 
			cols="60" 
			rows="6"><cfif (mododet NEQ "ALTA")>#HTMLEditFormat(Trim(rsFormDet.AFTFobservaciondetalle))#</cfif></textarea>
	</td>
	<td width="10%" align="right" nowrap="nowrap"><strong>Nuevo C.Funcional&nbsp;:&nbsp;</strong></td>
	<td>
		<cfset ValuesArray = ArrayNew(1)>
		<cfif (mododet NEQ 'ALTA')>
			<cfset ArrayAppend(ValuesArray,rsFormDet.CFid_lectura)>
			<cfset ArrayAppend(ValuesArray,rsFormDet.CFcodigo_lectura)>
			<cfset ArrayAppend(ValuesArray,rsFormDet.CFdescripcion_lectura)>
		</cfif>
		<cf_conlis form="formActivo" objForm="objFormActivo"  
			campos="CFid_lectura,CFcodigo_lectura,CFdescripcion_lectura, CFpath, CFnivel" 
			ValuesArray = "#ValuesArray#"
			desplegables="N,S,S"
			modificables="N,S,N"
			size="0,10,40"
			title="Lista de Centros Funcionales"
			tabla="CFuncional"
			columnas="distinct CFpath,CFnivel,CFid as CFid_lectura,CFcodigo as CFcodigo_lectura,CFdescripcion as CFdescripcion_lectura"
			filtro="CFuncional.Ecodigo = #session.Ecodigo# order by CFuncional.CFpath, CFuncional.CFcodigo, CFuncional.CFnivel"
			desplegar="CFcodigo_lectura,CFdescripcion_lectura"
			filtrar_por="CFuncional.CFcodigo,CFuncional.CFdescripcion"
			etiquetas="Código, Descripción"
			formatos="S,S"
			align="left,left"
			asignar="CFid_lectura,CFcodigo_lectura,CFdescripcion_lectura"
			asignarformatos="I,S,S"
			maxrowsquery="250"
			funcion="resetEmpleado_lectura" 
			tabindex="2">
	</td>
  <tr>
	<td width="10%" align="right" nowrap="nowrap"><strong>Nuevo Empleado&nbsp;:&nbsp;</strong></td>
	<td>
		<cfset ValuesArray=ArrayNew(1)>
		<cfif (mododet NEQ 'ALTA')>
			<cfset ArrayAppend(ValuesArray,rsFormDet.DEid_lectura)>
			<cfset ArrayAppend(ValuesArray,rsFormDet.DEidentificacion_lectura)>
			<cfset ArrayAppend(ValuesArray,rsFormDet.DEnombre_lectura)>
		</cfif>
		<cf_conlis form="formActivo" objForm="objFormActivo"  
			Campos="DEid_lectura,DEidentificacion_lectura,DEnombre_lectura"
			ValuesArray="#ValuesArray#"
			Desplegables="N,S,S"
			Modificables="N,S,N"
			Size="0,10,40"
			Title="Lista De Empleados"
			Tabla=" DatosEmpleado de
				left outer join LineaTiempo a
					on a.DEid = de.DEid
					and #hoy# between a.LTdesde and a.LThasta
				left outer join RHPlazas b 
					on b.RHPid = a.RHPid
					
				left outer join EmpleadoCFuncional decf
					on decf.DEid = de.DEid
					and #hoy# between decf.ECFdesde and decf.ECFhasta
				
				inner join CFuncional cf
					on cf.CFid = coalesce(b.CFid,decf.CFid)"
			Columnas="de.DEid as DEid_lectura,de.DEidentificacion as DEidentificacion_lectura, cf.CFid as CFid_lectura, cf.CFcodigo as CFcodigo_lectura, cf.CFdescripcion as CFdescripcion_lectura,
					{fn concat(de.DEapellido1,{fn concat(' ',{fn concat(de.DEapellido2,{fn concat(' ',de.DEnombre)})})})} as DEnombre_lectura"
			Filtro="de.Ecodigo = #session.Ecodigo# 
						 order by DEidentificacion"
			Desplegar="DEidentificacion_lectura,DEnombre_lectura"
			Etiquetas="Identificaci&oacute;n,Nombre"

			filtrar_por="de.DEidentificacion|{fn concat(de.DEapellido1,{fn concat(' ',{fn concat(de.DEapellido2,{fn concat(' ',de.DEnombre)})})})}"
			filtrar_por_delimiters="|"
			Formatos="S,S"
			Align="left,left"
			Asignar="DEid_lectura,DEidentificacion_lectura,DEnombre_lectura,CFid_lectura,CFcodigo_lectura,CFdescripcion_lectura"
			Asignarformatos="S,S,S,I,S,S"
			MaxRowsQuery="200"

			tabindex="2"/>
	</td>
  </tr>
</table>

<cf_botones modo="#mododet#" sufijo="Det" include="Lista" tabindex="3">

</cfoutput>
</form>

</fieldset>

</td>
</tr>
</table>

<!--- Funciones de los botones de la forma de captura de activos para la hoja de conteo --->
<script language="javascript" type="text/javascript">
	<!--//
	function funcListaDet() {
		deshabilitarValidacion();
		if (document.formActivo.AFTFid_detallehoja) document.formActivo.AFTFid_detallehoja.value="";
		document.formActivo.action = "aftfHojasCoteo.cfm";
		return true;
	}
	function funcNuevoDet() {
		deshabilitarValidacion();
		if (document.formActivo.AFTFid_detallehoja) document.formActivo.AFTFid_detallehoja.value="";
		document.formActivo.action = "aftfHojasCoteo.cfm";
		return true;
	}
	function funcLimpiarDet(){
		document.formActivo.reset();
		habilitarValidacion();
		setReadOnly(false);
		document.formActivo.Aplaca.focus();
	}
	function setReadOnly_formActivo_Adescripcion(pReadOnly){
		if (pReadOnly)
		{
			document.formActivo.Adescripcion.tabIndex 			= -1;
			document.formActivo.Adescripcion.readOnly			= true;
			document.formActivo.Adescripcion.style.border		= "solid 1px #CCCCCC";
			document.formActivo.Adescripcion.style.backGround	= "inherit";
		}
		else
		{
			document.formActivo.Adescripcion.tabIndex 			= 1;
			document.formActivo.Adescripcion.readOnly			= false;
			document.formActivo.Adescripcion.style.border		= window.Event ? "" : "inset 2px";
			document.formActivo.Adescripcion.style.backGround	= "";
		}
	
		return;
	}
	function setReadOnly_formActivo_Aserie(pReadOnly){
		if (pReadOnly)
		{
			document.formActivo.Aserie.tabIndex 			= -1;
			document.formActivo.Aserie.readOnly				= true;
			document.formActivo.Aserie.style.border			= "solid 1px #CCCCCC";
			document.formActivo.Aserie.style.backGround	= "inherit";
		}
		else
		{
			document.formActivo.Aserie.tabIndex 			= 2;
			document.formActivo.Aserie.readOnly				= false;
			document.formActivo.Aserie.style.border			= window.Event ? "" : "inset 2px";
			document.formActivo.Aserie.style.backGround	= "";
		}
	
		return;
	}
	function setReadOnly_formActivo_Avutil(pReadOnly){
		if (pReadOnly)
		{
			document.formActivo.Avutil.tabIndex 				= -1;
			document.formActivo.Avutil.readOnly				= true;
			document.formActivo.Avutil.style.border			= "solid 1px #CCCCCC";
			document.formActivo.Avutil.style.backGround	= "inherit";
		}
		else
		{
			document.formActivo.Avutil.tabIndex 				= 2;
			document.formActivo.Avutil.readOnly				= false;
			document.formActivo.Avutil.style.border			= window.Event ? "" : "inset 2px";
			document.formActivo.Avutil.style.backGround	= "";
		}
	
		return;
	}
	function setReadOnly_formActivo_Avalrescate(pReadOnly){
		if (pReadOnly)
		{
			document.formActivo.Avalrescate.tabIndex 				= -1;
			document.formActivo.Avalrescate.readOnly				= true;
			document.formActivo.Avalrescate.style.border			= "solid 1px #CCCCCC";
			document.formActivo.Avalrescate.style.backGround	= "inherit";
		}
		else
		{
			document.formActivo.Avalrescate.tabIndex 				= 2;
			document.formActivo.Avalrescate.readOnly				= false;
			document.formActivo.Avalrescate.style.border			= window.Event ? "" : "inset 2px";
			document.formActivo.Avutil.style.backGround	= "";
		}
	
		return;
	}
	function setReadOnly(pReadOnly){
		setReadOnly_formActivo_Aid(pReadOnly);
		setReadOnly_formActivo_AFCcodigo(pReadOnly);
		setReadOnly_formActivo_ACcodigo(pReadOnly);
		setReadOnly_formActivo_ACid(pReadOnly);
		setReadOnly_formActivo_AFMid(pReadOnly);
		setReadOnly_formActivo_AFMMid(pReadOnly);
		setReadOnly_formActivo_Adescripcion(pReadOnly);
		setReadOnly_formActivo_Aserie(pReadOnly);
		setReadOnly_formActivo_CFid(pReadOnly);
		setReadOnly_formActivo_DEid(pReadOnly);
		setReadOnly_formActivo_Avutil(pReadOnly);
		setReadOnly_formActivo_Avalrescate(pReadOnly);
	}
	function resetClase(){
		document.formActivo.ACid.value=''; 
		document.formActivo.ACcodigodesc_clas.value=''; 
		document.formActivo.ACdescripcion_clas.value='';
	}
	function resetModelo(){
		document.formActivo.AFMMid.value=''; 
		document.formActivo.AFMMcodigo.value=''; 
		document.formActivo.AFMMdescripcion.value='';
	}
	function resetEmpleado(){
		document.formActivo.DEid.value=''; 
		document.formActivo.DEidentificacion.value=''; 
		document.formActivo.DEnombre.value='';
	}
	function resetEmpleado_lectura(){
		document.formActivo.DEid_lectura.value=''; 
		document.formActivo.DEidentificacion_lectura.value=''; 
		document.formActivo.DEnombre_lectura.value='';
	}
	function AsignaCF(){
		alert ('tome');
	
	}
	function getAidInfo() {
		if (document.formActivo.Aid.value!=""){
			setReadOnly(true);
			document.formActivo.AFTFobservaciondetalle.focus();
			document.all["fr"].src="aftfHojasCoteo-getAidInfo.cfm?aid="+document.formActivo.Aid.value;
		}
	}
	
	<cfif (mododet NEQ 'ALTA')>
		document.formActivo.AFTFobservaciondetalle.focus();
	<cfelse>
		document.formActivo.Aplaca.focus();
	</cfif>
	//-->
</script>

<cf_qforms form="formActivo" objForm="objFormActivo">
	<cf_qformsRequiredField args="AFCcodigo,Tipo">
	<cf_qformsRequiredField args="ACcodigo,Categoria">
	<cf_qformsRequiredField args="ACid,Clase">
	<cf_qformsRequiredField args="AFMid,Marca">
	<cf_qformsRequiredField args="AFMMid,Modelo">
	<cf_qformsRequiredField args="Adescripcion,Descripcion">
	<cf_qformsRequiredField args="CFid,Centro Funcional">
	<cf_qformsRequiredField args="DEid,Responsable">
	<cf_qformsRequiredField args="Avutil,Vida Util">
	<cf_qformsRequiredField args="Avalrescate,Valor Rescate">
</cf_qforms>
<script language="javascript" type="text/javascript">
	<!--//
	objFormActivo.DEid_lectura.description = "Nuevo Responsable";
	//-->
</script>