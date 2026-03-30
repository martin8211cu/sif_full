<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_dbfunction name="to_char"	args="d.Aid"            returnvariable="Aid">
<cf_dbfunction name="to_char"	args="d.AFTDvalrescate" returnvariable="AFTDvalrescate">
<!---<cf_dbfunction name="to_char"	args="d.AFMid" returnvariable="AFMid">--->
<cf_dbfunction name="to_char"	args="d.AFTDid"         returnvariable="AFTDid">
<cf_dbfunction name="to_sdateDMY"	args="d.AFTDfechainidep"         returnvariable="AFTDfechainidep">

<form name="detAFVR" action="ValorRescate_sql.cfm" method="post">
	<cfoutput>
		<cfif isdefined('form.AFTRid')>
			<input type="hidden" name="AFTRid" value="#form.AFTRid#"/>

        </cfif>

		<cfquery name="slTipo" datasource="#session.dsn#">
			select AFTRtipo
			   from AFTRelacionCambio
			where AFTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFTRid#">
		</cfquery>
		<cfquery name="slGenera" datasource="#session.dsn#">
			select count(1) as cantidad
			    from AFTRelacionCambioD
		    where AFTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFTRid#">
		</cfquery>
		<cfset Navegacion ="">
		<cfset Navegacion = navegacion & 'AFTRid=' &#form.AFTRid#>
		<table width="100%">
			<!---TIPO 1: Cambio Valor de Rescate--->
			<cfif #slTipo.AFTRtipo# eq 1>
				<cfsavecontent variable="VR2">
					<cf_inputNumber name="Activo_AAAA" value="111.00" onblur="modificar(AAAA, this.value,1);" enteros = "10" decimales = "2">
				</cfsavecontent>
				<cfset VR2	= replace(VR2,"'","''","ALL")>
				<cfset VR2	= replace(VR2,"AAAA","' #_Cat# #Aid#  #_Cat# '","ALL")>
				<cfset VR2	= replace(VR2,"111.00","' #_Cat# #AFTDvalrescate#  #_Cat# '","ALL")>
				<cfset EL	= '<a href="javascript: borraDet(AAAA);"><img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif"></a>'>
				<cfset EL	= replace(EL,"'","''","ALL")>
				<cfset EL	= replace(EL,"AAAA","' #_Cat# #AFTDid#  #_Cat# '","ALL")>

				<cfquery name="slActivos" datasource="#session.dsn#">
				select '#PreserveSingleQuotes(EL)#' as eli,
						d.Aid,
						d.Adescripcion,
						d.Avalrescate,
						d.AFTDvalrescate,
						a.Afechainidep as fec,
						a.Aplaca,
						'#PreserveSingleQuotes(VR2)#' as VR
				from AFTRelacionCambioD d
				  inner join Activos a
					on a.Aid=d.Aid
				where AFTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFTRid#">
				order by a.Aplaca
				</cfquery>
				<tr>
					<td width="50%">
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
								query="#slActivos#"
								desplegar="eli,Aplaca,Adescripcion,fec,Avalrescate, VR"
								etiquetas="Eliminar,Activo,Descripci&oacute;n,FechaDep,Valor Rescate,Valor Rescate Nuevo"
								formatos="S,S,S,D,M,S"
								align="left,left,left,left,left,left"
								ira="ValorRescate_det.cfm"
								showlink="false" incluyeform="false"
								form_method="post"
								showEmptyListMsg="yes"
								keys="Aid"
								MaxRows="10"
								navegacion="#Navegacion#"/>
					</td>
				</tr>
			</cfif>
			<!---TIPO 2: Cambio de Descripcion--->
			<cfif #slTipo.AFTRtipo# eq 2>
					<cfset VR = '<input type="text" maxlength="100" name="Activo_'' #_Cat# #Aid#  #_Cat# ''" value="RRRR" onblur="javascript: modificarD('' #_Cat# #Aid#  #_Cat# '',this.name, this.value,2);"/>' >
					<cfset VR	= replace(VR,"RRRR","' #_Cat#  d.AFTDdescripcion  #_Cat# '","ALL")>
					<cfset EL	= '<a href="javascript: borraDet(AAAA);"><img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif"></a>'>
					<cfset EL	= replace(EL,"'","''","ALL")>
					<cfset EL	= replace(EL,"AAAA","' #_Cat# #AFTDid#  #_Cat# '","ALL")>
					<cfquery name="slActivos" datasource="#session.dsn#">
					select '#PreserveSingleQuotes(EL)#' as eli,
							d.Aid,
							d.Adescripcion,
							d.Avalrescate,
							a.Aplaca,
							a.Afechainidep as fec,
							d.AFTDdescripcion,
							'#PreserveSingleQuotes(VR)#' as VR
					from AFTRelacionCambioD d
					  inner join Activos a
						on a.Aid=d.Aid
					where AFTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFTRid#">
					order by a.Aplaca
					</cfquery>
				<tr>
					<td width="50%">
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
								query="#slActivos#"
								desplegar="eli,Aplaca,Adescripcion,fec,Avalrescate, VR"
								etiquetas="Eliminar,Activo,Descripci&oacute;n,FechaDep,Valor Rescate,Nueva Descripción"
								formatos="S,S,S,D,M,S"
								align="left,left,left,left,left,left"
								ira="ValorRescate_det.cfm"
								showlink="false" incluyeform="false"
								form_method="post"
								showEmptyListMsg="yes"
								keys="Aid"
								MaxRows="10"
								navegacion="#Navegacion#"
							/>
					</td>
				</tr>
			</cfif>
			<!---TIPO 3: Cambio de Fecha--->
			<cfif #slTipo.AFTRtipo# eq 3>
				<cfsavecontent variable="VR2">
				   <cf_inputNumber 	name="Activo_AAAA" value="111.00" onblur="modificar(AAAA,this.value,1);" enteros = "10" decimales = "2">
				</cfsavecontent>

				<cfset VR2	= replace(VR2,"'","''","ALL")>
				<cfset VR2	= replace(VR2,"AAAA","' #_Cat# #Aid#  #_Cat# '","ALL")>
				<cfset VR2	= replace(VR2,"111.00","' #_Cat# #AFTDvalrescate#  #_Cat# '","ALL")>
				<cfset VR = '<input type="text" size="50" maxlength="100" name="Activo_'' #_Cat# #Aid#  #_Cat# ''" value="RRRR" onblur="javascript: modificarD('' #_Cat# #Aid#  #_Cat# '',this.name, this.value);"/>' >
				<cfset VR	= replace(VR,"RRRR","' #_Cat# d.AFTDdescripcion  #_Cat# '","ALL")>
				<cfset EL	= '<a href="javascript: borraDet(AAAA);"><img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif"></a>'>
				<cfset EL	= replace(EL,"'","''","ALL")>
				<cfset EL	= replace(EL,"AAAA","' #_Cat# #AFTDid#  #_Cat# '","ALL")>

				<cfquery name="slActivos" datasource="#session.dsn#">
					select '#PreserveSingleQuotes(EL)#' as eli,
							d.Aid,
							d.Adescripcion,
							d.Avalrescate,
							d.AFTDvalrescate,
							AFTDdescripcion,
							a.Aplaca,
							a.Afechainidep as fec,
							'#PreserveSingleQuotes(VR)#' as descrip,
							'#PreserveSingleQuotes(VR2)#' as valor
					 from AFTRelacionCambioD d
						inner join Activos a
						  on a.Aid=d.Aid
					 where AFTRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFTRid#">
					 order by a.Aplaca
				</cfquery>
				<tr>
					<td width="50%">
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
								query="#slActivos#"
								desplegar="eli,Aplaca,Adescripcion,Avalrescate,fec ,descrip, valor"
								etiquetas="Eliminar,Activo,Descripci&oacute;n,Valor Rescate,FechaDep&nbsp;,Nueva Descripción, Nuevo Valor"
								formatos="S,S,S,M,D,S,S"
								align="left,left,left,left,left,left,left"
								ira="ValorRescate_det.cfm"
								showlink="false" incluyeform="false"
								form_method="post"
								showEmptyListMsg="yes"
								keys="Aid"
								MaxRows="10"
								navegacion="#Navegacion#"/>
					</td>
				</tr>
			</cfif>
			<!---TIPO 4: Todo--->
			<cfif #slTipo.AFTRtipo# eq 4>
				<cfset VF = '<input type="text" size="100" maxlength="100" name="Fecha_'' #_Cat# #Aid#  #_Cat# ''" value="RRRR" onblur="javascript: modificarF('' #_Cat# #Aid#  #_Cat# '',this.name, this.value);"/>' >
				<cfsavecontent variable="VF">
					<cf_sifcalendario form="detAFVR" name="Fecha_AAAA" value="111.00" tabindex="1" onblur="modificarF(AAAA,'Fecha_AAAA')">
				</cfsavecontent>
				<cfset VF	= replace(VF,"'","''","ALL")>
				<cfset VF	= replace(VF,"AAAA","' #_Cat# #Aid#  #_Cat# '","ALL")>
				<cfset VF	= replace(VF,"111.00","' #_Cat# #AFTDfechainidep# #_Cat# '","ALL")>

				<cfset EL	= '<a href="javascript: borraDet(AAAA);"><img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif"></a>'>
				<cfset EL	= replace(EL,"'","''","ALL")>
				<cfset EL	= replace(EL,"AAAA","' #_Cat# #AFTDid#  #_Cat# '","ALL")>

				<cfquery name="slActivos" datasource="#session.dsn#">
					select '#PreserveSingleQuotes(EL)#' as eli,
							d.Aid,
							d.Adescripcion,
							d.Avalrescate,
							a.Aplaca,
							a.Afechainidep as fecha,
							d.AFTDdescripcion,
							d.AFTDfechainidep,
							'#PreserveSingleQuotes(VF)#' as VF
					from AFTRelacionCambioD d
						inner join Activos a
							on a.Aid=d.Aid
					where AFTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFTRid#">
					order by a.Aplaca
				</cfquery>
				<tr>
					<td width="50%">
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
								query="#slActivos#"
								desplegar="eli,Aplaca,Adescripcion,fecha,Avalrescate, VF"
								etiquetas="Eliminar,Activo,Descripci&oacute;n,FechaDep,Valor Rescate,Nueva Fecha"
								formatos="S,S,S,D,M,S"
								align="left,left,left,left,left,left"
								ira="ValorRescate_det.cfm"
								showlink="false" incluyeform="false"
								form_method="post"
								showEmptyListMsg="yes"
								keys="Aid"
								MaxRows="10"
								navegacion="#Navegacion#"/>
					</td>
				</tr>
			</cfif>


      <!---TIPO 5 Garantia Empieza cambio RVD 04/06/2014--->
			<cfif #slTipo.AFTRtipo# eq 5>


				<cfset VF = '<input type="text" size="100" maxlength="100" name="Fecha_'' #_Cat# #Aid#  #_Cat# ''" value="RRRR" onblur="javascript: modificarF('' #_Cat# #Aid#  #_Cat# '',this.name, this.value);"/>' >

				<cfsavecontent variable="VF">
					<cf_sifcalendario form="detAFVR" name="Fecha_AAAA" value="111.00" tabindex="1" onblur="modificarF(AAAA,'Fecha_AAAA')">
				</cfsavecontent>
				<cfset VF	= replace(VF,"'","''","ALL")>
				<cfset VF	= replace(VF,"AAAA","' #_Cat# #Aid#  #_Cat# '","ALL")>
				<cfset VF	= replace(VF,"111.00","' #_Cat# #AFTDfechainidep# #_Cat# '","ALL")>

				<cfset EL	= '<a href="javascript: borraDet(AAAA);"><img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif"></a>'>
				<cfset EL	= replace(EL,"'","''","ALL")>
				<cfset EL	= replace(EL,"AAAA","' #_Cat# #AFTDid#  #_Cat# '","ALL")>

          		<cfsavecontent variable="Mar" >
                      <cf_sifMarcaMod  tabindexMar="1" tabindexMod="1" form="detAFVR"
                      nameMar = AFMcodigo_XXXX
                      nameMod= AFMMcodigo_YYYY
                      keyMar = AFMid_XXXX
                      keyMod = AFMMid_YYYY
                      descMar = AFMdescripcion_XXXX
                      descMod = AFMMdescripcion_YYYY
                      altMar = Marca_XXXX
                      altMod = Modelo_YYYY
                      Aid = "XXXX"
                      funcionMar = "funcModificarM"
                      funcionMod = "funcModificarMod"
                      Modificable = "true"
                      orientacion = "H"
                      size = 20>

         		</cfsavecontent>

		 		<cfset Mar = replace(Mar,"'","''","ALL")>

            	<cfset Mar	= replace(Mar,"XXXX","' #_Cat# #Aid#  #_Cat# '","ALL")>
            	<cfset Mar	= replace(Mar,"YYYY","' #_Cat# #Aid#  #_Cat# '","ALL")>

               	<!---<cfsavecontent variable="Tipo" >
                     <cf_siftipoactivo id="AFCcodigo_ZZZZ"
                     name="AFCcodigoclas_ZZZZ"
                     nivel = "Nnivel_ZZZZ"
                     frame = "frclasificacion_ZZZZ"
                     desc = "AFCdescripcion_ZZZZ"
                     Aid = "ZZZZ"
                     form="detAFVR"
                     size = 20
                     sizeCod = 10
                     funcionTipo = "funcModificarTipo"
                     tabindex="1">
                </cfsavecontent>

				<cfset Tipo = replace(Tipo,"'","''","ALL")>
                <cfset Tipo	= replace(Tipo,"ZZZZ","' #_Cat# #Aid#  #_Cat# '","ALL")> --->


				<!--- JMRV. Inicio. Para garantia, se agregan los campos de num de serie y observaciones. 18/07/2014--->

				<!--- Campo para el numero de serie --->
				<cfsavecontent variable="Aserie">
					<input type="text" size="20" maxlength="40" name="Aserie" value="" onblur="javascript:modificaValor(AAAA, 'Aserie', this.value,5);"/>
				</cfsavecontent>
				<cfset Aserie	= replace(Aserie,"'","''","ALL")>
				<cfset Aserie	= replace(Aserie,"AAAA","' #_Cat# #Aid# #_Cat# '","ALL")>

				<!--- Campo para las observaciones --->
				<cfsavecontent variable="observacion">
					<input type="text" size="40" maxlength="150" name="obs" value="" onblur="javascript:modificaValor(AAAA, 'observacion', this.value,5);"/>
				</cfsavecontent>
				<cfset observacion	= replace(observacion,"'","''","ALL")>
				<cfset observacion	= replace(observacion,"AAAA","' #_Cat# #Aid# #_Cat# '","ALL")>

				<cfquery name="slActivos" datasource="#session.dsn#">
					select '#PreserveSingleQuotes(EL)#' as eli,
							d.Aid,
							d.Adescripcion,
							d.Avalrescate,
							a.Aplaca,
							a.Afechainidep as fecha,
							d.AFTDdescripcion,
							d.AFTDfechainidep,
							<!--- a.Aserie as Serie, --->
							b.AFMdescripcion as Marca,
                            d.AFMid,
                            b.AFMdescripcion,
							c.AFMMdescripcion as Modelo,
							<!--- '#PreserveSingleQuotes(Tipo)#' as Tipo, --->
							'#PreserveSingleQuotes(VF)#' as VF,
                            '#PreserveSingleQuotes(Mar)#' as Mar,
							'#PreserveSingleQuotes(Aserie)#' as Aserie,
							'#PreserveSingleQuotes(observacion)#' as Observacion
                        from AFTRelacionCambioD d
						inner join Activos a
							on a.Aid=d.Aid
						inner join AFMarcas b
						on a.AFMid = b.AFMid
						inner join AFMModelos c
						on b.AFMid = c.AFMid
						and a.AFMMid = c.AFMMid
                      	inner join AFClasificaciones e
						on e.AFCcodigo = a.AFCcodigo
					where AFTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFTRid#">
					order by a.Aplaca
				</cfquery>

				<tr>
					<td width="50%">
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
								query="#slActivos#"
								desplegar="eli,Aplaca,Adescripcion,Mar,Aserie, Observacion"
								etiquetas="Eliminar,Activo,Descripci&oacute;n,Marca y Modelo,Serie, Observacion"
								formatos="S,S,S,S,S,S,S"
								align="left,left,left,left,left,rigth,left"
								ira="ValorRescate_det.cfm"
								showlink="false" incluyeform="false"
								form_method="post"
								showEmptyListMsg="yes"
								keys="Aid"
								MaxRows="10"
								navegacion="#Navegacion#"/>
					</td>
				</tr>
			</cfif>

			<!--- JMRV. Fin. 18/07/2014--->
<!---TIPO 5 Garantia Termina cambio RVD 04/06/2014--->


		</table>
		<iframe name="ifrCambioVal" id="ifrCambioVal" marginheight="0" marginwidth="10" frameborder="0" height="0" width="0" scrolling="auto"></iframe>
	</cfoutput>
</form>
<cfoutput>
<script language="javascript1.2" type="text/javascript">
	function modificar(aid, value,tipo){
		if (value != "")
		{
			activo=aid;
			valor=value;
			document.getElementById('ifrCambioVal').src = 'CambiaValores.cfm?valor='+qf(valor)+'&activo='+activo+'&tipo='+1+'&id='+#form.AFTRid#+'';
		}
	}
	function modificarD(adescripcion,name, value){

		if (value != ""){
		activo=adescripcion
		descripcion=value
		document.getElementById('ifrCambioVal').src = 'CambiaValores.cfm?descrip='+descripcion+'&activo='+activo+'&tipo='+2+'&id='+#form.AFTRid#+'';
			}
		}

	function funcModificarM(Aid, AFMid){<!---Se agrega Función para Cambio de Valores de Activo Fijo por Garantía RVD 04/06/2014--->

		if (AFMid != ""){
		activo=Aid
		marca = AFMid
		document.getElementById('ifrCambioVal').src = 'CambiaValores.cfm?marca='+AFMid+'&activo='+Aid+'&tipo='+5+'&id='+#form.AFTRid#+'&Cambio='+"Marca"+'';
			}
		}


	function funcModificarMod(Aid, AFMMid){<!---Se agrega Función para Cambio de Valores de Activo Fijo por Garantía RVD 04/06/2014--->

		if (AFMMid != ""){
		activo=Aid
		modelo = AFMMid
		document.getElementById('ifrCambioVal').src = 'CambiaValores.cfm?modelo='+AFMMid+'&activo='+Aid+'&tipo='+5+'&id='+#form.AFTRid#+'&Cambio='+"Modelo"+'';
			}
		}

	<!---
	function funcModificarTipo(Aid, AFCcodigo){<!---Se agrega Función para Cambio de Valores de Activo Fijo por Garantía RVD 04/06/2014--->


		if (AFCcodigo != ""){
		activo=Aid
		Tipo = AFCcodigo
		document.getElementById('ifrCambioVal').src = 'CambiaValores.cfm?AFCcodigo='+Tipo+'&activo='+Aid+'&tipo='+5+'&id='+#form.AFTRid#+'&Cambio='+"Tipo"+'';

			}
		}
	--->

	<!--- JMRV. Inicio. Funcion para modificar el valor de los campos "num de serie" y "observaciones". 18/07/2014 --->

	function modificaValor(aid, modificar, value, tipo){
		if (value != "")
		{
			if (modificar == "Aserie")
			{
				activo=aid;
				Aserie=value;
				document.getElementById('ifrCambioVal').src = 'CambiaValores.cfm?Aserie='+Aserie+'&activo='+activo+'&tipo='+tipo+'&id='+#form.AFTRid#+'&Cambio='+"Aserie"+'';
			}

			if (modificar == "observacion")
			{
				activo=aid;
				observacion=value;
				document.getElementById('ifrCambioVal').src = 'CambiaValores.cfm?observacion='+observacion+'&activo='+activo+'&tipo='+tipo+'&id='+#form.AFTRid#+'&Cambio='+"Observacion"+'';
			}
		}
	}

	<!--- JMRV. Fin. 18/07/2014 --->


	function modificarF(activo,name){
			fechaSTR=document.getElementById(name).value;
			document.getElementById('ifrCambioVal').src = 'CambiaValores.cfm?fecha='+fechaSTR+'&activo='+activo+'&tipo='+3+'&id='+#form.AFTRid#+'';
		}

	function Valida(){
		return confirm('¿Está seguro(a) de que desea eliminar el registro?')
	}

	function borraDet(AFTDid){
		if (Valida()){
			document.form1.BorrarDet.value = AFTDid;
			document.form1.BorrarDet.click();
		}
	}

</script>
</cfoutput>