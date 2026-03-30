<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfparam name="url.CRDRplaca" default="-1">
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElActivoFueRetirado"
	Default="El Activo fué Retirado"
	returnvariable="MSG_ElActivoFueRetirado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Adquisicion"
	Default="Adquisición"
	returnvariable="LB_Adquisicion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Mejoras"
	Default="Mejora"
	returnvariable="LB_Mejoras"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElActivoExiste"
	Default="El Activo Existe"
	returnvariable="MSG_ElActivoExiste"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElActivoEstaEnTransito"
	Default="El Activo Existe en un Documento en Tránsito"
	returnvariable="MSG_ElActivoEstaEnTransito"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElActivoNoHayVale"
	Default="El Activo existe, pero no tienen documento de Responsabilidad."
	returnvariable="MSG_ElActivoNoHayVale"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NOPermiteValeMejora"
	Default="No esta permitido la generación de vales por concepto de mejora."
	returnvariable="MSG_NOPermiteValeMejora"/>
<script>
<cfquery name="rsDocumentosVale" datasource="#Session.DSN#">
	select 1
 	  from CRDocumentoResponsabilidad
	where Ecodigo = #Session.Ecodigo#
	  and rtrim(ltrim(CRDRplaca)) = <cfqueryparam value="#Trim(url.placa)#" cfsqltype="cf_sql_char">
    <cfif isdefined("url.crdrid") and len(trim(url.crdrid)) GT 0>
	  and CRDRid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.crdrid#">
   </cfif>
	  and CRDRestado in (0,10)
</cfquery>
<cfif rsDocumentosVale.recordcount gt 0><!---AF en Transito--->
		alert("<cfoutput>#MSG_ElActivoEstaEnTransito#</cfoutput>");
		window.parent.document.form1.CRDRplaca_text2.value="";
		window.parent.document.form1.CRDRplaca.value="";
		window.parent.document.form1.AFCMejora.value="0";
		window.parent.document.form1.CRDRplaca.focus();		
<cfelse><!---No es AF transito--->
	<cfquery name="rsPlaca" datasource="#Session.DSN#">
		select Aid, Astatus
		from Activos
		where Ecodigo = #Session.Ecodigo#
		and Aplaca    = <cfqueryparam value="#Trim(url.placa)#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfif rsPlaca.recordcount EQ 0><!---AF no Existente--->
			<!---<cfif isdefined('url.placa') and #Trim(url.placa)# NEQ ''> --->
			<cfif isdefined('url.placa') and #Trim(url.placa)# NEQ ''
				and isdefined('url.valorMejoraUrl') and #url.valorMejoraUrl# eq 1>
				alert("El activo no esta registrado");
			</cfif>
			window.parent.document.form1.CRDRplaca_text2.value="<cfoutput>#LB_Adquisicion#</cfoutput>";	
			window.parent.document.form1.CRDRplacaA.value="";	
			window.parent.document.form1.AFCMejora.value="0";
			DesHabilitaBotones(false);
	<cfelse><!---AF Existente--->
		<cfif rsPlaca.Astatus EQ 60><!---AF Retirado--->
				alert("<cfoutput>#MSG_ElActivoFueRetirado#</cfoutput>");
				window.parent.document.form1.CRDRplaca_text2.value="";
				window.parent.document.form1.CRDRplaca.value="";
				window.parent.document.form1.AFCMejora.value="0";
				window.parent.document.form1.CRDRplaca.focus();
				limpiarTodo();
		<cfelse><!---AF No Retirado--->
			<cfquery name="NOPermiteValesMejora" datasource="#session.DSN#">
				select Pvalor from Parametros where Ecodigo = #session.Ecodigo# and Pcodigo = 1300
			</cfquery>
			<cfif NOPermiteValesMejora.Pvalor EQ 1><!---No permite Vales por Concepto de Mejoras--->
					alert("<cfoutput>#MSG_NOPermiteValeMejora#</cfoutput>");
					window.parent.document.form1.CRDRplaca_text2.value="";
					window.parent.document.form1.CRDRplaca.value="";
					window.parent.document.form1.AFCMejora.value="0";
					window.parent.document.form1.CRDRplaca.focus();	
			<cfelse><!---Permite Vales de Mejoras(AF vrs CM vrs CP)--->
				<cfquery name="AFResponsables" datasource="#Session.DSN#">
					select 1
					   from AFResponsables
					where Aid = #rsPlaca.Aid#
					and <cf_dbfunction name="now"> between AFRfini and AFRffin
				</cfquery>
				<cfif AFResponsables.recordcount EQ 0><!---AF Existente sin Responsables--->
						alert("<cfoutput>#MSG_ElActivoNoHayVale#</cfoutput>");	
						window.parent.document.form1.CRDRplaca_text2.value="";
						window.parent.document.form1.CRDRplaca.value="";
						window.parent.document.form1.AFCMejora.value="0";
						window.parent.document.form1.CRDRplaca.focus();
				<cfelse><!---Mejora--->
					   <cfquery name="rsActivo" datasource="#Session.DSN#">		
							select
								F.ACcodigo 		CategoriaID,
								F.ACcodigodesc 	CategoriaCodigo,
								F.ACdescripcion CategoriaDescribe,
								G.ACid 			ClaseID,
								G.ACcodigodesc 	ClaseCodigo, 
								G.ACdescripcion ClaseDescribe,
								C.Adescripcion,
								I.AFMid,
								I.AFMcodigo,
								I.AFMdescripcion,
								L.AFMMid,
								L.AFMMcodigo,
								L.AFMMdescripcion,
								J.AFCcodigo,
								J.AFCcodigoclas,
								J.AFCdescripcion,
								C.Aserie,
								K.CRTDid,
								K.CRTDcodigo,
								K.CRTDdescripcion,
								D.DEid,
								D.DEidentificacion,
								D.DEnombre #_Cat#' '#_Cat# D.DEapellido1 #_Cat#' '#_Cat# D.DEapellido2 as DEnombrecompleto,
								H.CFid,
								H.CFcodigo,
								H.CFdescripcion,
								Coalesce(B.CRDRdescdetallada,B.CRDRdescripcion) DescripcionDet
									
								from AFResponsables B
									inner join Activos C on 
										B.Aid = C.Aid and
										B.Ecodigo = C.Ecodigo
									left outer join CRTipoCompra tcp on	
										B.CRTCid  = tcp.CRTCid and 
										B.Ecodigo = tcp.Ecodigo
									left outer join DatosEmpleado D on 
										B.DEid 	= D.DEid and 
										B.Ecodigo = D.Ecodigo
									left outer join CRCentroCustodia E on
										B.Ecodigo = E.Ecodigo and 
										B.CRCCid  = E.CRCCid
									left outer join ACategoria F on
										C.Ecodigo = F.Ecodigo and
										C.ACcodigo = F.ACcodigo
									left outer join AClasificacion G on
										C.Ecodigo = G.Ecodigo and
										C.ACcodigo = G.ACcodigo and
										C.ACid = G.ACid
									left outer join CFuncional H on
										B.CFid = H.CFid and 
										B.Ecodigo = H.Ecodigo
									left outer join Oficinas O on
										O.Ocodigo = H.Ocodigo and 
										O.Ecodigo = H.Ecodigo
									left outer join AFMarcas I on
										C.AFMid  = I.AFMid and 
										C.Ecodigo = I.Ecodigo
									left outer join AFClasificaciones J on
										C.AFCcodigo  = J.AFCcodigo and 
										C.Ecodigo = J.Ecodigo
									left outer join CRTipoDocumento K on
										B.Ecodigo = K.Ecodigo and
										B.CRTDid = K.CRTDid
									left outer join AFMModelos L on
										C.Ecodigo = L.Ecodigo and
										C.AFMMid = L.AFMMid
								where B.Ecodigo  = #Session.Ecodigo#
								and rtrim(ltrim(C.Aplaca)) = <cfqueryparam value="#Trim(url.placa)#" cfsqltype="cf_sql_char">
								and <cf_dbfunction name="now"> between  B.AFRfini and B.AFRffin
						</cfquery>
							llenarTodo();
							DesHabilitaBotones(true);
							window.parent.document.form1.Monto.focus();
							function llenarTodo()
							{
							<cfoutput>
							  window.parent.document.form1.CRDRplaca_text2.value="#LB_Mejoras#";	
							   window.parent.document.form1.CRDRdescripcion.value="#rsActivo.Adescripcion#";
								window.parent.document.form1.ACcodigo.value="#rsActivo.CategoriaID#";
								 window.parent.document.form1.ACcodigodesc.value="#rsActivo.CategoriaCodigo#";
								  window.parent.document.form1.ACdescripcion.value="#rsActivo.CategoriaDescribe#";
								   window.parent.document.form1.ACid.value="#rsActivo.ClaseID#";
									window.parent.document.form1.Cat_ACcodigodesc.value="#rsActivo.ClaseCodigo#";
									 window.parent.document.form1.Cat_ACdescripcion.value="#rsActivo.ClaseDescribe#";
									  window.parent.document.form1.AFMid.value="#rsActivo.AFMid#";
									   window.parent.document.form1.AFMcodigo.value="#rsActivo.AFMcodigo#";
										window.parent.document.form1.AFMdescripcion.value="#rsActivo.AFMdescripcion#";
										 window.parent.document.form1.AFMMid.value="#rsActivo.AFMMid#";
										  window.parent.document.form1.AFMMcodigo.value="#rsActivo.AFMMcodigo#";
										   window.parent.document.form1.AFMMdescripcion.value="#rsActivo.AFMMdescripcion#";
											window.parent.document.form1.CRTDid.value="#rsActivo.CRTDid#";
											 window.parent.document.form1.AFCcodigo.value="#rsActivo.AFCcodigo#";
											  window.parent.document.form1.AFCcodigoclas.value="#rsActivo.AFCcodigoclas#";
											   window.parent.document.form1.AFCdescripcion.value="#rsActivo.AFCdescripcion#";
												window.parent.document.form1.AFCdescripcion.value="#rsActivo.AFCdescripcion#";
												 window.parent.document.form1.CRDRdescdetallada.value="#rsActivo.DescripcionDet#";
												  window.parent.document.form1.CRDRserie.value="#rsActivo.Aserie#";
												   window.parent.document.form1.CRTDcodigo.value="#rsActivo.CRTDcodigo#";
													window.parent.document.form1.CRTDdescripcion.value="#rsActivo.CRTDdescripcion#";
													 window.parent.document.form1.DEid.value="#rsActivo.DEid#";
													  window.parent.document.form1.DEidentificacion.value="#rsActivo.DEidentificacion#";
													   window.parent.document.form1.DEnombrecompleto.value="#rsActivo.DEnombrecompleto#";
														window.parent.document.form1.CFid.value="#rsActivo.CFid#";
														 window.parent.document.form1.CFcodigo.value="#rsActivo.CFcodigo#";
														  window.parent.document.form1.CFdescripcion.value="#rsActivo.CFdescripcion#";
														   window.parent.document.form1.AFCMejora.value="1";
							</cfoutput>
							}
				</cfif><!---Fin Mejora--->
			</cfif><!---Fin Permite Vales de Mejoras--->
		</cfif><!---Fin AF No Retirado--->
	</cfif>	<!---Fin AF Existente--->
</cfif><!---Fin No es AF transito--->
		function limpiarTodo()
		{
		<cfif not isdefined("url.crdrid") or len(trim(url.crdrid)) EQ 0>
		 window.parent.document.form1.CRDRplaca_text2.value="";
		  window.parent.document.form1.CRDRdescripcion.value="";
		   window.parent.document.form1.ACdescripcion.value="";
			window.parent.document.form1.ACcodigodesc.value="";
			 window.parent.document.form1.ACdescripcion.value="";
			  window.parent.document.form1.AFMMdescripcion.value="";
			   window.parent.document.form1.Cat_ACcodigodesc.value="";
				window.parent.document.form1.Cat_ACdescripcion.value="";
				 window.parent.document.form1.AFMcodigo.value="";
				  window.parent.document.form1.AFMdescripcion.value="";
				   window.parent.document.form1.AFMMcodigo.value="";
					window.parent.document.form1.AFCcodigoclas.value="";
					 window.parent.document.form1.AFCdescripcion.value="";
					  window.parent.document.form1.AFCdescripcion.value="";
					   window.parent.document.form1.CRDRdescdetallada.value="";
						window.parent.document.form1.CRDRserie.value="";
						 window.parent.document.form1.CRTDcodigo.value="";
						  window.parent.document.form1.CRTDdescripcion.value="";
						   window.parent.document.form1.DEidentificacion.value="";
							window.parent.document.form1.DEnombrecompleto.value="";
							 window.parent.document.form1.CFcodigo.value="";
							  window.parent.document.form1.CFdescripcion.value="";
							   window.parent.document.form1.AFCMejora.value="";
		</cfif>
		}

		function DesHabilitaBotones(valor)
		{
		  window.parent.document.form1.CRDRdescripcion.readOnly = valor;
		   window.parent.document.form1.ACcodigodesc.readOnly = valor;
		    window.parent.document.form1.Cat_ACcodigodesc.readOnly = valor;
	         window.parent.document.form1.AFMcodigo.readOnly = valor;
			  window.parent.document.form1.AFMMcodigo.readOnly = valor;
		       window.parent.document.form1.AFCcodigoclas.readOnly = valor;
			    window.parent.document.form1.CRDRdescdetallada.readOnly = valor;
				 window.parent.document.form1.CRDRserie.readOnly = valor;
				  window.parent.document.form1.CRTDcodigo.readOnly = valor;
				   window.parent.document.form1.DEidentificacion.readOnly = valor;
		}
</script>