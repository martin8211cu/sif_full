<!--- 	ULTIMA ACTUALIZACION 03/07/2006
		Actualizado por Gustavo Fonseca H.
		Utiliza Componente de Listas.

		ULTIMA ACTUALIZACION 13/10/2005
		11 de Octubre del 2005, Se Modificó Fuente Original para que utilizara el Componente de Listas 100%.
		Actualizado por Dorian A.G.
		Utiliza Tags de Montos, Qforms, BOTONES y Nuevos Tags creados a la fecha.
 --->

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Documento" default="Documento" returnvariable="LB_Documento" xmlfile="listaMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion" xmlfile="listaMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Tipo" default="Tipo" returnvariable="LB_Tipo" xmlfile="listaMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" xmlfile="listaMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Usuario" default="Usuario" returnvariable="LB_Usuario" xmlfile="listaMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mov" default="Mov" returnvariable="LB_Mov" xmlfile="listaMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Monto" default="Monto" returnvariable="LB_Monto" xmlfile="listaMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cuenta" default="Cuenta" returnvariable="LB_Cuenta" xmlfile="listaMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_MarcaAplica" default="Debe marcar al menos un elemento de la lista para realizar esta accion!" returnvariable="MSG_MarcaAplica" xmlfile="listaMovimientos.xml"/>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
 </cfsavecontent>
 <cfinvoke component="sif.Componentes.TranslateDB"
    method="Translate"
    VSvalor="#nav__SScodigo#.#nav__SMcodigo#.#nav__SPcodigo#"
    Default="#nav__SPdescripcion#"
    VSgrupo="103"
    Idioma="#session.idioma#"
    returnvariable="translated_Title"/>
<cf_templateheader title="#translated_Title#">
<cfif isdefined('LvarTCE') and len(trim(#LvarTCE#)) gt 0>
<cfset _Pagina = 'TCEMovimientos.cfm'>
<cfelse>
<cfset _Pagina = 'Movimientos.cfm'>
</cfif>
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_dbfunction name="string_part" args="cb.CBcodigo,1,25" returnvariable="CBcodigo" datasource="#session.dsn#">
	<cf_web_portlet_start titulo="<cfoutput>#translated_Title#</cfoutput>">
		<cfquery name="rsCBdescripcion" datasource="#session.dsn#">
			select -1 as value, '-- todos --' as description, 0 as ord from dual
			union
			select distinct cb.CBid as value, #CBcodigo# as description, 1 as ord
			from EMovimientos em
					inner join CuentasBancos cb
						on  em.Ecodigo=cb.Ecodigo
						and em.CBid=cb.CBid
					inner join BTransacciones bt
						on  em.Ecodigo=bt.Ecodigo
						and em.BTid=bt.BTid
			where em.Ecodigo = #session.Ecodigo#
            	and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			order by 3,2
		</cfquery>
		<cf_dbfunction name="string_part" args="bt.BTcodigo,1,25" returnvariable="BTcodigo" datasource="#session.dsn#">

		<cfquery name="rsBTdescripcion" datasource="#session.dsn#">
			select -1 as value, 'todos' as description, 0 as ord from dual
			union
			select distinct bt.BTid as value, #BTcodigo# as description, 1 as ord
			from EMovimientos em
					inner join CuentasBancos cb
						on  em.Ecodigo=cb.Ecodigo
						and em.CBid=cb.CBid
					inner join BTransacciones bt
						on  em.Ecodigo=bt.Ecodigo
						and em.BTid=bt.BTid
			where em.Ecodigo = #session.Ecodigo#
            	and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			order by 3,2
		</cfquery>

		<cfquery name="rsUsuario" datasource="#session.DSN#">
		select distinct EMusuario as value, Rtrim(EMusuario) as description
			from EMovimientos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			union
			select ' ' as value, ' ' as description from dual
			order by 1
		</cfquery>

		<cf_dbfunction name="concat" args="'#LB_Cuenta#: ', cb.CBcodigo" returnvariable="LvarCBcodigo">
		<cfset varCBesTCE=0>
		<cfif isdefined('LvarTCE')>
				<cfset varCBesTCE=1>
		</cfif>

<!---		<cfinvoke            -----                      LISTA ANTERIOR PARA SOLO MOVIMIENTOS BANCARIOS
			Component= "sif.Componentes.pListas"
			method="pLista"
			returnvariable="pListaRet"
			columnas = "em.EMdocumento,
			   em.EMdescripcion,
			   bt.BTcodigo as BTdescripcion,
			   em.EMfecha,
			   #LvarCBcodigo# as CBdescripcion,
			   em.EMid,
			   em.EMusuario,
			   coalesce(( select sum(DMmonto)
					  from DMovimientos
					  where EMid=em.EMid
					  and Ecodigo=em.Ecodigo ), EMtotal )  as monto,
				case coalesce(TpoSocio,0) when 0 then 'Bancos' when 1 then 'Cliente' when 2 then 'Proveedor' end as  TpoSocio,
					  '' as e"
			tabla = "EMovimientos em
					inner join CuentasBancos cb
						on  em.Ecodigo=cb.Ecodigo
						and em.CBid=cb.CBid
					inner join BTransacciones bt
						on  em.Ecodigo=bt.Ecodigo
						and em.BTid=bt.BTid"
			filtro="em.Ecodigo = #Session.Ecodigo# and cb.CBesTCE = #varCBesTCE# order by cb.CBcodigo, em.EMdocumento"
			mostrar_filtro = "true"
			filtrar_automatico = "true"
			filtrar_por = "em.EMdocumento, em.EMdescripcion, em.BTid, em.EMfecha, em.EMusuario, , , "
			desplegar="EMdocumento, EMdescripcion, BTdescripcion, EMfecha, EMusuario,TpoSocio, monto, e"
			etiquetas="Documento, Descripci&oacute;n, Tipo, Fecha, Usuario, Mov, Monto, "
			formatos="S,S,S,D,S,U,UM,U"
			align="left, left, left, center, left, right, right,right"
			checkboxes="S"
			ira="#_Pagina#"
			nuevo="#_Pagina#"
			showemptylistmsg="true"
			keys="EMid"
			botones="Nuevo,Aplicar,Imprimir"
			rsbtdescripcion="#rsBTdescripcion#"
			rsEMusuario="#rsUsuario#"
			maxrows="100"
			maxrowsquery="200"
			debug="N"
			cortes="CBdescripcion"
		/>
		--->

		<!--- se Agrega cb.CBesTCE = #varCBesTCE# para filtrar con las cuentas TCE, si CBesTCE= "1" es TCE, si CBesTCE= "O", es para bancos--->
		<cfinvoke component="sif.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="EMovimientos em
														inner join CuentasBancos cb
															on  em.Ecodigo=cb.Ecodigo
															and em.CBid=cb.CBid
														inner join BTransacciones bt
															on  em.Ecodigo=bt.Ecodigo
															and em.BTid=bt.BTid"/>
				<cfinvokeargument name="columnas" value="em.EMdocumento,
														   em.EMdescripcion,
														   bt.BTcodigo,
														   em.EMfecha,
														   #LvarCBcodigo# as CBdescripcion,
														   em.EMid,
														   em.EMusuario,
														   coalesce(( select sum(DMmonto)
																  from DMovimientos
																  where EMid=em.EMid
																  and Ecodigo=em.Ecodigo ), EMtotal )  as monto,
															case coalesce(TpoSocio,0) when 0 then 'Bancos' when 1 then 'Cliente' when 2 then 'Proveedor' end as  TpoSocio,
																  '' as e"/>
				<cfinvokeargument name="desplegar" value="EMdocumento, EMdescripcion, BTcodigo, EMfecha, EMusuario,TpoSocio, monto, e"/>
				<cfinvokeargument name="etiquetas" value="#LB_Documento#, #LB_Descripcion#, #LB_Tipo#, #LB_Fecha#, #LB_Usuario#, #LB_Mov#, #LB_Monto#"/>
				<cfinvokeargument name="checkboxes" value="S"/>
				<cfinvokeargument name="filtro" value="em.Ecodigo = #Session.Ecodigo# and cb.CBesTCE = #varCBesTCE# order by cb.CBcodigo, em.EMdocumento"/>
				<cfinvokeargument name="align" value="left, left, left, left, left, left, left,left"/>
				<cfinvokeargument name="nuevo" value="#_Pagina#"/>
				<cfinvokeargument name="irA" value="#_Pagina#"/>
				<cfinvokeargument name="keys" value="EMid"/>
				<cfinvokeargument name="PageIndex" value="2"/>
				<cfinvokeargument name="formatos" value="S,S,S,D,S,U,UM,U"/>
				<cfinvokeargument name="mostrar_filtro" value="true"/>
				<cfinvokeargument name="filtrar_automatico" value="true"/>
				<cfinvokeargument name="maxrows" value="100"/>

				<cfinvokeargument name="botones" value="Nuevo,Aplicar,Imprimir"/>
				<cfinvokeargument name="showemptylistmsg" value="true"/>
			<!---	<cfinvokeargument name="rsbtdescripcion" value="#rsBTdescripcion#"/>--->
				<cfinvokeargument name="rsEMusuario" value="#rsUsuario#">
				<cfinvokeargument name="maxrowsquery" value="200"/>
				<cfinvokeargument name="cortes" value="CBdescripcion"/>
				<cfinvokeargument name="debug" value="N"/>


			</cfinvoke>



	<cf_web_portlet_end>
<cf_templatefooter>

<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// ============================================================================
	// Llama a la pantalla del reporte
	// ============================================================================
	var popUpWin=0;

	function popUpWindowReporte(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popupWindow', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}

	function algunoMarcado(){
		f = document.lista;

		if (f.chk != null) {
			if (f.chk.value) {
				if (f.chk.checked) {
					return true;
				}
			} else {
				for (var i=0; i<f.chk.length; i++) {
					if (f.chk[i].checked) {
						return true;
					}
				}
			}
		}
		alert("<cfoutput>#MSG_MarcaAplica#</cfoutput>");
		return false;
	}

	function funcNuevo(){
		document.lista.EMID.value='';
		document.lista.action="<cfoutput>#_Pagina#</cfoutput>";
	}

	function funcAplicar(){
		if (algunoMarcado()){
			document.lista.action="<cfoutput>#_Pagina#</cfoutput>";
		}
		else{ return false; }

		return true;
	}

	function getMarcados(){
		var f = document.lista;
		var m = "";
		if (f.chk != null) {
			if (f.chk.value) {
				if (f.chk.checked) {
					m = f.chk.value;
				}
			} else {
				for (var i=0; i<f.chk.length; i++) {
					if (f.chk[i].checked) {
						if (m.length==0)
							m = f.chk[i].value;
						else
							m += ',' + f.chk[i].value;
					}
				}
			}
		}
		return m;
	}

	function funcImprimir(){
		if (algunoMarcado()){

		<cfif isdefined('LvarTCE') and len(trim(#LvarTCE#)) gt 0><!---  varTCE  indica si es una reporte para para TCE o bancos--->
			document.lista.action = "../../mb/Reportes/RPRegistroMovBancariosMasivo-frame.cfm?lista="+getMarcados()+"&varTCE=1";
		<cfelse>
			document.lista.action = "../../mb/Reportes/RPRegistroMovBancariosMasivo-frame.cfm?lista="+getMarcados()+"&varTCE=0";
		</cfif>
			document.lista.submit();
		}
		return false; //Siempre Retorn falso porque lo que hace es levantar una pantalla cuando hay marcados.
	}

	//-->

	function getMarcados(){
		var f = document.lista;
		var m = "";
		if (f.chk != null) {
			if (f.chk.value) {
				if (f.chk.checked) {
					m = f.chk.value;
				}
			} else {
				for (var i=0; i<f.chk.length; i++) {
					if (f.chk[i].checked) {
						if (m.length==0)
							m = f.chk[i].value;
						else
							m += ',' + f.chk[i].value;
					}
				}
			}
		}
		return m;
	}

	function funcAplicar(){
		var info = getInfoMB();
		if(info === "error"){
			return false;
		} else {
			if(confirm(info)){
				return true;
			} else {
				return false;
		    }
		}
		return false;
	}

	function getInfoMB(){
		var idMB = getMarcados();
		var infoMB = "";
		if(idMB === ""){
			alert("Favor de seleccionar al menos un documento.")
			infoMB = "error"
		} else {
			$.ajax({
			    method: "post",
			    url: "ajaxObtenerMovimientos.cfc",
			    async: false,
			    data: {
			        method: "getInfoMovimientosBancarios",
			        returnFormat: "JSON",
			        idMovimientos: idMB,
			    },
			    dataType: "json",
			    success: function(obj) {
			        if (obj.MSG == 'operacionOK') {
			        	infoMB = obj.INFO;
			        } else {
			            alert(obj.MSG);
			            infoMB = "error"
			        }
			    }
			});
		}
		return infoMB;
	}
</script>

