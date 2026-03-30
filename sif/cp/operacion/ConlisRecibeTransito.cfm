<cfinclude template="/edu/Utiles/general.cfm">
<html>
<head>
<title>Aplicacion de Documentos en Transito</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<link href="../../css/edu.css" rel="stylesheet" type="text/css">
</head>
<body>

<cfif isdefined("Form.btnAplicar")>

	<cfif isdefined("Form.Chk")>
		<cfset a=ListToArray(Form.Chk,',')>
		<cfloop index="i" from="1" to="#ArrayLen(a)#">
			<cfset b = ListToArray(a[i],'|')>
			 <cfset TRid = b[1]>
			<cfquery name="ABC_DRecibeTransito" datasource="#Session.DSN#">
				insert into DRecibeTransito (ERTid, TRid, Aid, DRTcantidad, Aid, DRTfecha, Ddocumento DRTcostoU, Ucodigo, Kunidades, Kcosto)
				select a.ERTid, a.TRid, a.Aid as Alm.Aid, a.TRCantidad, a.Aid Art_Id, <cf_dbfunction name="now"> , a.Ddocumento, #form.CostoU#, b.Ucodigo, 0,0
				from  Transito a, Articulos b 
				where a.TRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#TRid#">
				   a.Aid = b.Aid
			</cfquery>
		</cfloop>
		 <script language="JavaScript">
			window.close();
		</script>
		<cfabort>
	</cfif>
 </cfif>
     <table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr> 
    <td align="center"> 

      <form name="filtros" action="ConlisRecibeTransito.cfm" method="post">
	  	<p class="tituloAlterno">&nbsp; Pendientes de Recibir: </p>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
          <tr> 
            <td width="30%" align="right" style="padding-right: 10 px;"><strong>Embarque</strong></td>
            <td width="30%" nowrap> 
              <cfquery datasource="#Session.DSN#" name="rsEmbarque">
				  select distinct TREmbarque as Codigo, b.TREmbarque
				  from Transito a, ERecibeTransito b, DRecibeTransito c
				  where b.ERTid = c.ERTid
				    and a.TRid  = c.TRid
				    and b.TRcantidad <> c.DRTcantidad
				  order by TRFecha
              </cfquery>
              <select name="TRid" id="TRid" tabindex="1" >
                <option value="-1">Todos</option>
                <cfoutput query="rsEmbarque"> 
                  <option value="#Codigo#">#rsEmbarque.TREmbarque#</option>
                </cfoutput> 
              </select>
              <strong>Costo Unitario:</strong><input name="Kcosto" type="text" id="Kcosto" size="20" tabindex="1" maxlength="100" onFocus="javascript:this.select();" value="">
            </td>
            <td width="40%"> 
            	<input name="Filtrar" type="submit" value="Filtrar">
            	<input name="Limpiar" type="button" value="Limpiar" onClick="javascript: LimpiarFiltros(this.form); ">
            </td>
          </tr>
        </table>
        </form>
		</td>
              </tr>
              <tr> 
                <td><strong> &nbsp;&nbsp;&nbsp; 
                  <input name="chkTodos" type="checkbox" value="" border="1" onClick="javascript:Marcar(this);">
                  Seleccionar Todos</strong></td>
              </tr>
              <tr> 
                <td>
					<form name="lista" method="post" action="ConlisRecibeTransito.cfm">
					<input type="hidden" name="Hcodigo" value="<cfif isdefined("Form.Hcodigo")><cfoutput>#Form.Hcodigo#</cfoutput></cfif>">
					<input name="Cual_Tran" type="hidden" id="Cual_Tran" value="">

					<cfset navegacion = "">
					<cfset filtro = "">
					<cfif isdefined("Form.Pagina") and Form.Pagina NEQ "">
                    	<cfset Pagenum_lista = Form.Pagina>
                  	</cfif> 
					<cfif isdefined("Form.TRid") and (Len(Trim(Form.TRid)) NEQ 0) and (Form.TRid NEQ "-1")>
						<cfset filtro = "and b.TRid = "  & #Trim(Form.TRid)# >
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "TRid=" & Form.TRid>
					</cfif>
					
					<cf_dbfunction name="to_char"     args="a.ERTid"    returnvariable="ERTid">
					<cf_dbfunction name="to_sdateDMY" args="ERTfecha"   returnvariable="ERTfecha">
					<cfinvoke 
						 component="edu.Componentes.pListas"
						 method="pListaEdu"
						 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="ERecibeTransito a, DRecibeTransito b, Transito c"/>
						<cfinvokeargument name="columnas" value="#PreserveSingleQuotes(ERTid)# as ERTid, #PreserveSingleQuotes(ERTfecha)# as fecha, #PreserveSingleQuotes(ERTid)# as checked"/>
						<cfinvokeargument name="desplegar" value="fecha, usuario"/>
						<cfinvokeargument name="etiquetas" value="Descripcion, Usuario"/>
						<cfinvokeargument name="formatos" value=""/>
						<cfinvokeargument name="filtro" value=" and b.TRid  = c.TRid
																and c.TRcantidad <> b.DRTcantidad
																order by TRFecha "/>
						<cfinvokeargument name="align" value="left, left"/>
						<cfinvokeargument name="ajustar" value="N,N"/>
						<cfinvokeargument name="irA" value="ConlisRecibeTransito.cfm"/>
						<cfinvokeargument name="cortes" value=""/>
						<cfinvokeargument name="checkboxes" value="S"/>
						<cfinvokeargument name="debug" value="N"/>
						<cfinvokeargument name="maxrows" value="10"/>
						<cfinvokeargument name="incluyeForm" value="false"/>
						<cfinvokeargument name="formName" value="lista"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="keys" value="ERTid"/>
						<cfinvokeargument name="checkedcol" value="checked"/>
						<cfinvokeargument name="botones" value="Aplicar"/>
					</cfinvoke>
					
						 <script language="JavaScript">
						 	if (document.lista.chk != null) {
								if (document.lista.chk.value != null) {
									if (document.lista.chk.checked) document.lista.chk.checked = true; else document.lista.chk.checked = false;
										var a = document.lista.chk.value.split("|");
										var TRid = a[0];
										document.lista.Cual_Tran.value += TRid ;
								} else {
									for (var counter = 0; counter < document.lista.chk.length; counter++) {
										var a = document.lista.chk[counter].value.split("|");
										var TRid = a[0];
										document.lista.Cual_Tran.value += TRid + ",";
									}
									if (document.lista.Cual_Tran.value != "") {
										document.lista.Cual_Tran.value = document.lista.Cual_Tran.value.substring(0,document.lista.Cual_Tran.value.length-1);
									}
								}
							}
						</script>
					</form>
				 </td>
              </tr>
            </table>
	  <script language="JavaScript1.2">
		function Marcar(c) {
			if (document.lista.chk != null) { //existe?
				if (document.lista.chk.value != null) {// solo un check
					if (c.checked) document.lista.chk.checked = true; else document.lista.chk.checked = false;
				}
				else {
					if (c.checked) {
						for (var counter = 0; counter < document.lista.chk.length; counter++)
						{
							if ((!document.lista.chk[counter].checked) && (!document.lista.chk[counter].disabled))
								{  document.lista.chk[counter].checked = true;}
						}
						if ((counter==0)  && (!document.lista.chk.disabled)) {
							document.lista.chk.checked = true;
						}
					}
					else {
						for (var counter = 0; counter < document.lista.chk.length; counter++)
						{
							if ((document.lista.chk[counter].checked) && (!document.lista.chk[counter].disabled))
								{  document.lista.chk[counter].checked = false;}
						};
						if ((counter==0) && (!document.lista.chk.disabled)) {
							document.lista.chk.checked = false;
						}
					};
				}
			}
		}

		function LimpiarFiltros(f) {
			f.TRid.selectedIndex = 0;
		}
	  </script>

</body>
</html>