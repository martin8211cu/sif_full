<cfinclude template="/sif/Utiles/general.cfm">
<html>
<head>
<title>Recepción de Artículos en Tránsito</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<link href="../../css/edu.css" rel="stylesheet" type="text/css">
</head>
<body>
<cfif isdefined("Url.ERTid") and not isdefined("Form.ERTid")>
	<cfset form.ERTid = Url.ERTid>
</cfif> 

<cfif isdefined("Url.Alm_Aid") and not isdefined("Form.Alm_Aid")>
	<cfset form.Alm_Aid = Url.Alm_Aid>
</cfif> 

<cfif isdefined("Url.Ddocumento_filtro") and not isdefined("Form.Ddocumento_filtro")>
	<cfset form.Ddocumento_filtro = Url.Ddocumento_filtro>
</cfif> 

<cfif isdefined("Form.btnAplicar")>
	<cfif isdefined("Form.Chk")>
		
		<cfset a=ListToArray(Form.Chk,',')>
		<cfloop index="i" from="1" to="#ArrayLen(a)#">
			<cfset b = ListToArray(a[i],'|')>
			<cfset Tid = b[1]>
			<cfset cantidad = b[2]>
			<cfquery name="ABC_Embarque" datasource="#Session.DSN#">
				  select distinct a.Tembarque as Embarquelin
				  from Transito a
				  where a.Tid = #Tid#
			</cfquery>
			
			<cfset Embarque = ABC_Embarque.Embarquelin>
			<cfquery datasource="#Session.DSN#">
				insert into DRecibeTransito 
				(
					ERTid, 
					Tid, 
					Alm_Aid, 
					DRTcantidad, 
					Aid, 
					DRTfecha, 
					Ddocumento, 
					DRTcostoU, 
					Ucodigo, 
					Kunidades, 
					Kcosto,
					DRTembarque, 
					DRTgananciaperdida
				)
				select 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERTid#">,
					a.Tid,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Alm_Aid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#cantidad#">,
					a.Aid as Art_Id,
					<cf_dbfunction name="now">,
					a.Ddocumento,
					case when a.Tcantidad != 0 then round(a.TcostoLinea / a.Tcantidad, 6) else 0.00 end,
					b.Ucodigo,
					0,
					0,
					<cf_dbfunction name="to_char" args="'#Embarque#'"> as Embarque,
					0
				from Transito a
					inner join Articulos b 
					   on a.Tid = #Tid#
				      and a.Aid = b.Aid
			</cfquery>		
			<cfquery datasource="#Session.DSN#">
				update Transito 
					set Trecibido = Trecibido + #cantidad#
				where Ecodigo = #Session.Ecodigo#
			  	  and Tid 	  = #Tid#
			</cfquery>
		</cfloop>
		<script language="JavaScript">
			window.opener.document.form1.action = "";
			window.opener.document.form1.submit();			
			window.close();
		</script>
		<cfabort>
	</cfif>
 </cfif>
  <cfquery datasource="#Session.DSN#" name="rsEmbarque">
	   select distinct Tembarque as Codigo, Tembarque, Tfecha 
		 from Transito 
		where Tcantidad > Trecibido 
		  and Tid not in (select b.Tid 
							from ERecibeTransito a
							  inner join DRecibeTransito b 
								 on a.ERTid = b.ERTid                 
						   where a.Ecodigo = #Session.Ecodigo#) 
		order by Tfecha 
  </cfquery>
<cfset navegacion = "">
					<cfset filtro = "">
					<cfif isdefined("Form.Pagina") and Form.Pagina NEQ "">
						<cfset Pagenum_lista = Form.Pagina>
					</cfif> 
					<cfif isdefined("Form.Tid") and (Len(Trim(Form.Tid)) NEQ 0) and (Form.Tid NEQ "-1")>
						<cfset filtro = "and Tid = "  & Trim(Form.Tid)>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Tid=" & Form.Tid>
					</cfif>
					
					<cfif isdefined("Form.Tembarque") and (Len(Trim(Form.Tembarque)) NEQ 0) and (Form.Tembarque NEQ "-1")>
						<cfset filtro = "and Tembarque = '"  & Trim(Form.Tembarque) & "'">
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Tembarque=" & Form.Tembarque>
					</cfif>
					
					<cfif isdefined("Form.Ddocumento_filtro") and (Len(Trim(Form.Ddocumento_filtro)) NEQ 0)>
						<cfset filtro = "and upper(Ddocumento) like '%"  & Ucase(Trim(Form.Ddocumento_filtro)) & "%'">
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Ddocumento_filtro=" & Form.Ddocumento_filtro>
					</cfif>
					
					
					<cf_dbfunction name="to_char" args="Tid" returnvariable ="Tid"> 
					<cf_dbfunction name="to_date00" args="Tfecha" returnvariable ="fecha">
					<cf_dbfunction name="to_char" args="IDdocumento" returnvariable ="IDdocumento"> 
					<cf_dbfunction name="concat" args="#preservesinglequotes(Tid)#+'|'+#preservesinglequotes(IDdocumento)#"  returnvariable="doc" delimiters = "+">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr> 
		<td align="center"> 	
			<form name="filtros" action="ConlisMasivo.cfm" method="post">
				<input type="hidden" name="ERTid"   value="<cfif isdefined("Form.ERTid")><cfoutput>#Form.ERTid#</cfoutput></cfif>">
				<input type="hidden" name="Alm_Aid" value="<cfif isdefined("Form.Alm_Aid")><cfoutput>#Form.Alm_Aid#</cfoutput></cfif>">
				<p class="tituloAlterno">&nbsp; Artículos en Tránsito: </p>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
			  		<tr> 
						<td width="30%" align="right" style="padding-right: 10 px;"><strong>Embarque</strong></td>
						<td width="30%" nowrap> 
							<select name="Tembarque" id="Tembarque" tabindex="1" >
							<option value="-1">Todos</option>
								<cfoutput query="rsEmbarque"> 
									<option value="#Codigo#" <cfif isdefined("form.Tembarque") and #codigo# EQ form.Tembarque >selected</cfif>>#rsEmbarque.Tembarque#</option> 
								</cfoutput> 
				 	 		</select>
				  			<strong>Documento Referencia:</strong>
							<input name="Ddocumento_filtro" type="text" id="Ddocumento_filtro" size="20" tabindex="1" maxlength="100" onFocus="javascript:this.select();" value="<cfif isdefined("form.Ddocumento_filtro") and len(trim(form.Ddocumento_filtro)) NEQ 0><cfoutput>#trim(form.Ddocumento_filtro)#</cfoutput></cfif>">
						</td>
						<td width="40%"> 
							<input name="Filtrar" type="submit" value="Filtrar" class="btnFiltrar">
							<input name="Limpiar" type="button" value="Limpiar" class="btnLimpiar" onClick="javascript: LimpiarFiltros(this.form); ">
						</td>
			  		</tr>
				</table>
			</form>
		</td>
	</tr>
	<tr> 
		<td>		
			<form name="lista" method="post" action="ConlisMasivo.cfm">
				<table width="100%" border="0" cellpadding="1" cellspacing="1">
					<tr>				
						<td>
							<strong>&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="chkTodos"  value="" border="1" onClick="javascript: Marcar(this);">Seleccionar Todos</strong>
							<input type="hidden"   name="Tid" 		value="<cfif isdefined("Form.Tid")><cfoutput>#Form.Tid#</cfoutput></cfif>">
							<input type="hidden"   name="ERTid" 	value="<cfif isdefined("Form.ERTid")><cfoutput>#Form.ERTid#</cfoutput></cfif>">
							<input type="hidden"   name="Alm_Aid" 	value="<cfif isdefined("Form.Alm_Aid")><cfoutput>#Form.Alm_Aid#</cfoutput></cfif>">
							<input type="hidden"   name="Cual_Tran" value="" id="Cual_Tran" >
						</td>				
					</tr>
					<tr>
						<td>
							<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
								<cfinvokeargument name="tabla" 			value="Transito"/>
								<cfinvokeargument name="conexion" 		value="#Session.DSN#">
								<cfinvokeargument name="columnas" 		value="distinct #preservesinglequotes(Tid)# as Tid, Ddocumento, Tembarque, #preservesinglequotes(fecha)# as fecha,(Tcantidad - Trecibido) as Saldo, #preservesinglequotes(doc)#  as checked"/>
								<cfinvokeargument name="desplegar" 		value="Ddocumento, Tembarque, fecha, Saldo "/>
								<cfinvokeargument name="etiquetas" 		value="Documento, Embarque, Fecha del Embarque, Saldo"/>
								<cfinvokeargument name="formatos" 		value="S,S,D,I"/>
								<cfinvokeargument name="filtro" 		value=" Tcantidad > Trecibido and Ecodigo = #Session.Ecodigo# #filtro# order by Ddocumento, Tembarque"/>
								<cfinvokeargument name="align" 			value="left, left, left, left"/>
								<cfinvokeargument name="ajustar" 		value="N,N,N,N"/>
								<cfinvokeargument name="irA" 			value="ConlisMasivo.cfm"/>						
								<cfinvokeargument name="checkboxes" 	value="S"/>
								<cfinvokeargument name="maxrows" 		value="10"/>
								<cfinvokeargument name="incluyeForm" 	value="false"/>
								<cfinvokeargument name="formName" 		value="lista"/>						
								<cfinvokeargument name="debug" 			value="N"/>
								<cfinvokeargument name="cortes" 		value=""/>
								<cfinvokeargument name="navegacion" 	value="#navegacion#"/>
								<cfinvokeargument name="keys" 			value="Tid,Saldo"/>
								<cfinvokeargument name="checkedcol" 	value="checked"/>
								<cfinvokeargument name="botones" 		value="Aplicar"/>
								<cfinvokeargument name="showLink" 		value="false"/>		
							</cfinvoke>				
						</td>
					</tr>
				</table>
			</form>
		</td>
	</tr>
</table>
<script language="JavaScript">						 
		if (document.lista.chk != null) {
			if (document.lista.chk.value != null) {
				if (document.lista.chk.checked) document.lista.chk.checked = true; else document.lista.chk.checked = false;
					var a = document.lista.chk.value.split("|");
					var Tid = a[0];
					document.lista.Cual_Tran.value += Tid ;
			} else {
				for (var counter = 0; counter < document.lista.chk.length; counter++) {
					var a = document.lista.chk[counter].value.split("|");
					var Tid = a[0];
					document.lista.Cual_Tran.value += Tid + ",";
				}
				if (document.lista.Cual_Tran.value != "") {
					document.lista.Cual_Tran.value = document.lista.Cual_Tran.value.substring(0,document.lista.Cual_Tran.value.length-1);
				}
			}
		}							

	function Marcar(c) {
		if (document.lista.chk != null) { //existe?
			if (document.lista.chk.value != null) {// solo un check
				
				if (c.checked) 
					document.lista.chk.checked = true; 						
				else
					document.lista.chk.checked = false;
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
					}
					if ((counter==0) && (!document.lista.chk.disabled)) {
						document.lista.chk.checked = false;
					}
				}
			}				
		}
	}
	function LimpiarFiltros(f) {
		//alert(f.Ddocumento_filtro.value);
		f.Tembarque.selectedIndex = 0;
		f.Ddocumento_filtro.value= '';
	}
</script>
</body>
</html>