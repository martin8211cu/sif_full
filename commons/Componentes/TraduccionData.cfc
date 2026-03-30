<cfcomponent>
	<cffunction name="getTablas" returntype="array">
	<cfargument name="tabla"  type="string" required="no">
        <cfargument name="squema"  type="string" required="yes">
		<cfset listTablas= ArrayNew(1)>
		<cfif not listfindnocase('asp,sifcontrol',arguments.squema)>
		<cfset x = StructNew()>
                <cfset x.tabla='CIncidentes'>
                <cfset x.cols='CIdescripcion'>	 
                <cfset x.llave='CIid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='CategoriaNoticias'>
                <cfset x.cols='DescCategoria'>   
                <cfset x.llave='IdCategoria'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='ECargas'>
                <cfset x.cols='ECdescripcion'>	 
                <cfset x.llave='ECid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHVigenciasTabla'>
                <cfset x.cols='RHVTdescripcion'>   
                <cfset x.llave='RHVTid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='RHReportesNomina'>
                <cfset x.cols='RHRPTNdescripcion'>   
                <cfset x.llave='RHRPTNid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='RHColumnasReporte'>
                <cfset x.cols='RHCRPTdescripcion'>   
                <cfset x.llave='RHCRPTid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='EncabNoticias'>
                <cfset x.cols='Titulo'>   
                <cfset x.llave='IdNoticia'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='DCargas'>
                <cfset x.cols='DCdescripcion'>	 
                <cfset x.llave='DClinea'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>	

                <cfset x = StructNew()>
                <cfset x.tabla='DetNoticias'>
                <cfset x.cols='Contenido'>   
                <cfset x.llave='IdNoticia'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='SNegocios'>
                <cfset x.cols='SNnombre'>	 
                <cfset x.llave='SNid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='GrupoSNegocios'>
                <cfset x.cols='GSNdescripcion'>        
                <cfset x.llave='GSNid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='TDeduccion'>
                <cfset x.cols='TDdescripcion'>	 
                <cfset x.llave='TDid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>	
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHTipoAccion'>
                <cfset x.cols='RHTdesc'>	 
                <cfset x.llave='RHTid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='RHTAccionMasiva'>
                <cfset x.cols='RHTAdescripcion'>         
                <cfset x.llave='RHTAid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='CFuncional'>
                <cfset x.cols='CFdescripcion'>	 
                <cfset x.llave='CFid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='Oficinas'>
                <cfset x.cols='Odescripcion'>	 
                <cfset x.llave='Ecodigo,Ocodigo'>
                <cfset x.llaveType='n,n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='Departamentos'>
                <cfset x.cols='Ddescripcion'>	 
                <cfset x.llave='Ecodigo,Dcodigo'>
                <cfset x.llaveType='n,n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='GradoAcademico'>
                <cfset x.cols='GAnombre'>	 
                <cfset x.llave='Ecodigo,GAcodigo'>
                <cfset x.llaveType='n,n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='TiposNomina'>
                <cfset x.cols='Tdescripcion'>	 
                <cfset x.llave='Ecodigo,Tcodigo'>
                <cfset x.llaveType='n,v'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='RegimenVacaciones'>
                <cfset x.cols='Descripcion'>	 
                <cfset x.llave='RVid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHJornadas'>
                <cfset x.cols='RHJdescripcion'>	 
                <cfset x.llave='RHJid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHPlazas'>
                <cfset x.cols='RHPdescripcion'>	 
                <cfset x.llave='RHPid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='RHPrioridadDed'>
                <cfset x.cols='RHPDdescripcion'>  
                <cfset x.llave='RHPDid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>                
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHPuestos'>
                <cfset x.cols='RHPdescpuesto'>	 
                <cfset x.llave='Ecodigo,RHPcodigo'>
                <cfset x.llaveType='n,v'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='RHPuestosExternos'>
                <cfset x.cols='RHPEdescripcion'>   
                <cfset x.llave='RHPEid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='RHECatalogosGenerales'>
                <cfset x.cols='RHECGdescripcion'>   
                <cfset x.llave='RHECGid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='RHDCatalogosGenerales'>
                <cfset x.cols='RHDCGdescripcion'>   
                <cfset x.llave='RHDCGid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>  

                <cfset x = StructNew()>
                <cfset x.tabla='RHHFactores'>
                <cfset x.cols='RHHFdescripcion'>   
                <cfset x.llave='RHHFid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>     

                <cfset x = StructNew()>
                <cfset x.tabla='RHHSubfactores'>
                <cfset x.cols='RHHSFdescripcion'>   
                <cfset x.llave='RHHSFid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>    
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHDescriptivoPuesto'>
                <cfset x.cols='RHDPmision,RHDPobjetivos,RHDPespecificaciones'>	 
                <cfset x.llave='Ecodigo,RHPcodigo'>
                <cfset x.llaveType='n,v'>
                <cfset ArrayAppend(listTablas,x)>
                            
                <cfset x = StructNew()>
                <cfset x.tabla='RHEDatosVariables'>
                <cfset x.cols='RHEDVdescripcion'>	 
                <cfset x.llave='RHEDVid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHDDatosVariables'>
                <cfset x.cols='RHDDVdescripcion,RHDDVvalor'>	 
                <cfset x.llave='RHDDVlinea'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHHabilidades'>
                <cfset x.cols='RHHdescripcion,RHHdescdet'>	 
                <cfset x.llave='RHHid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHIHabilidad'>
                <cfset x.cols='RHIHdescripcion'>	 
                <cfset x.llave='RHIHid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>		
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHNiveles'>
                <cfset x.cols='RHNdescripcion'>	 
                <cfset x.llave='RHNid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>		
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHComportamiento'>
                <cfset x.cols='RHCOdescripcion'>	 
                <cfset x.llave='RHCOid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>		
                    
                <cfset x = StructNew()>
                <cfset x.tabla='RHEAreasEvaluacion'>
                <cfset x.cols='RHEAdescripcion'>	 
                <cfset x.llave='RHEAid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='RHDAreasEvaluacion'>
                <cfset x.cols='RHDAdescripcion,RHDAobs'>         
                <cfset x.llave='RHDAlinea'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHConcursos'>
                <cfset x.cols='RHCdescripcion,RHCjustificacion,RHCotrosdatos,RHCsedetrabajo,RHCtipocontrato'>	 
                <cfset x.llave='RHCconcurso'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHConocimientos'>
                <cfset x.cols='RHCdescripcion'>	 
                <cfset x.llave='RHCid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHEEvaluacionDes'>
                <cfset x.cols='RHEEdescripcion'>	 
                <cfset x.llave='RHEEid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHOcupaciones'>
                <cfset x.cols='RHOdescripcion'>	 
                <cfset x.llave='RHOcodigo'>
                <cfset x.llaveType='v'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='RHOPuesto'>
                <cfset x.cols='RHOPDescripcion'>  
                <cfset x.llave='RHOPid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='RHOIndustria'>
                <cfset x.cols='RHOIDescripcion'>  
                <cfset x.llave='RHOIid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHComponentesAgrupados'>
                <cfset x.cols='RHCAdescripcion'>	 
                <cfset x.llave='RHCAid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHCategoria'>
                <cfset x.cols='RHCdescripcion'>	 
                <cfset x.llave='RHCid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHMaestroPuestoP'>
                <cfset x.cols='RHMPPdescripcion'>	 
                <cfset x.llave='RHMPPid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                            
                <cfset x = StructNew()>
                <cfset x.tabla='ComponentesSalariales'>
                <cfset x.cols='CSdescripcion'>	 
                <cfset x.llave='CSid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHConfigReportePuestos'>
                <cfset x.cols='CRPeini,CRPeubicacion,CRPeespecif,CRPepie,CRPeobjetivo,CRPemision,CRPeconocim,CRPeHAY,CRPehabilidad,CRPePuntajes,CRPeencab,CRPeAutoria'>	 
                <cfset x.llave='CRPid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHDVPuesto'>
                <cfset x.cols='RHDDVvalor'>	 
                <cfset x.llave='RHDDVlinea,Ecodigo,RHPcodigo'>
                <cfset x.llaveType='n,n,v'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='EFormato'>
                <cfset x.cols='EFdescripcion,EFdescalterna'>	 
                <cfset x.llave='EFid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='DFormato'>
                <cfset x.cols='DFtexto'>	 
                <cfset x.llave='DFlinea'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='Empresas'>
                <cfset x.cols='Edescripcion'>	 
                <cfset x.llave='Ecodigo'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='RHParentesco'>
                <cfset x.cols='Pdescripcion'>	 
                <cfset x.llave='Pid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='Monedas'>
                <cfset x.cols='Mnombre'>  
                <cfset x.llave='Mcodigo'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='NTipoIdentificacion'>
                <cfset x.cols='NTIdescripcion'>	 
                <cfset x.llave='NTIcodigo,Ecodigo'>
                <cfset x.llaveType='v,n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHEtiquetasEmpresa'>
                <cfset x.cols='RHEtiqueta'>	 
                <cfset x.llave='RHEcol,Ecodigo'>
                <cfset x.llaveType='v,n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHEtiquetasOferente'>
                <cfset x.cols='RHEtiqueta'>	 
                <cfset x.llave='Ecodigo,RHEcol'>
                <cfset x.llaveType='n,v'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='RHExportaciones'>
                <cfset x.cols='RHEdescripcion'>      
                <cfset x.llave='Ecodigo,Bid,EIid'>
                <cfset x.llaveType='n,n,n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <!------ etickets----->
                <cfset x = StructNew()>
                <cfset x.tabla='RHTicketTipo'>
                <cfset x.cols='TTKdesc,TTKobs'>	 
                <cfset x.llave='TTKid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                <cfset x = StructNew()>
                <cfset x.tabla='RHTicketPrioridad'>
                <cfset x.cols='TKPRdesc'>	 
                <cfset x.llave='TKPRid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                <cfset x = StructNew()>
                <cfset x.tabla='RHTicketPasos'>
                <cfset x.cols='TKPPdesc,TKPPobs'>	 
                <cfset x.llave='TKPPid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
    
                <cfset x = StructNew()>
                <cfset x.tabla='RHMotivos'>
                <cfset x.cols='RHMdescripcion'>	 
                <cfset x.llave='RHMid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHPruebas'>
                <cfset x.cols='RHPdescripcionpr'>	 
                <cfset x.llave='Ecodigo,RHPcodigopr'>
                <cfset x.llaveType='n,v'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHTablasRangos'>
                <cfset x.cols='TBRdescripcion'>	 
                <cfset x.llave='TBRid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='TiposEmpleado'>
                <cfset x.cols='TEdescripcion'>	 
                <cfset x.llave='TEid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                        
                <cfset x = StructNew()>
                <cfset x.tabla='RHTPuestos'>
                <cfset x.cols='RHTPdescripcion'>	 
                <cfset x.llave='RHTPid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHFeriados'>
                <cfset x.cols='RHFdescripcion'>	 
                <cfset x.llave='RHFid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)> 
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHTTablaSalarial'>
                <cfset x.cols='RHTTdescripcion'>	 
                <cfset x.llave='RHTTid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>   
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHOTitulo'>
                <cfset x.cols='RHOTDescripcion'>	 
                <cfset x.llave='RHOTid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>     
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHOEnfasis'>
                <cfset x.cols='RHOEDescripcion'>	 
                <cfset x.llave='RHOEid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>  
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHReporteProvisionesC'>
                <cfset x.cols='RPCdescripcion'>	 
                <cfset x.llave='RPCid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>    
                
                <cfset x = StructNew()>
                <cfset x.tabla='TipoExpediente'>
                <cfset x.cols='TEdescripcion'>	 
                <cfset x.llave='TEid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>    
                
                <cfset x = StructNew()>
                <cfset x.tabla='RHIdiomas'>
                <cfset x.cols='RHDescripcion'>	 
                <cfset x.llave='RHIid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>   
    
                <cfset x = StructNew()>
                <cfset x.tabla='RHPublicacionTipo'>
                <cfset x.cols='RHPTDescripcion'>	 
                <cfset x.llave='RHPTid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='ZonasEconomicas'>
                <cfset x.cols='ZEdescripcion'>         
                <cfset x.llave='ZEid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='GrupoSNegocios'>
                <cfset x.cols='GSNdescripcion'>         
                <cfset x.llave='GSNid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
        
                <cfset x = StructNew()>
                <cfset x.tabla='WfActivity'>
                <cfset x.cols='Name,Description,Documentation'>
                <cfset x.llave='ActivityId'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='WfProcess'>
                <cfset x.cols='Name,Description,Documentation'>
                <cfset x.llave='ProcessId'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='WfPackage'>
                <cfset x.cols='Name,Description,Documentation'>
                <cfset x.llave='PackageId'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='WfTransition'>
                <cfset x.cols='Description,Label'>
                <cfset x.llave='TransitionId'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='WfParticipant'>
                <cfset x.cols='Name,Description'>
                <cfset x.llave='ParticipantId'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='WfApplication'>
                <cfset x.cols='Description,Documentation'>
                <cfset x.llave='ApplicationName'>
                <cfset x.llaveType='v'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='WfDataField'>
                <cfset x.cols='Description,Label'>
                <cfset x.llave='DataFieldName,ProcessId'>
                <cfset x.llaveType='v,n'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='WfxActivityParticipant'>
                <cfset x.cols='Description'>
                <cfset x.llave='ParticipantId,ActivityInstanceId,Usucodigo'>
                <cfset x.llaveType='n,n,n'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='WfxProcess'>
                <cfset x.cols='Description'>
                <cfset x.llave='ProcessInstanceId'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)> 

                <cfset x = StructNew()>
                <cfset x.tabla='WfFormalParameter'>
                <cfset x.cols='Description'>
                <cfset x.llave='ApplicationName,ParameterName'>
                <cfset x.llaveType='v,v'>
                <cfset ArrayAppend(listTablas,x)>
            </cfif>
            <cfif isdefined("arguments.squema") and arguments.squema eq 'asp'>
				<cfset x = StructNew()>
                <cfset x.tabla='UnidadGeografica'>
                <cfset x.cols='UGdescripcion'>	 
                <cfset x.llave='UGid'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
                <cfset x = StructNew()>
                <cfset x.tabla='AreaGeografica'>
                <cfset x.cols='AGdescripcion'>	 
                <cfset x.llave='AGid'>
                <cfset x.llaveType='n'>
                <cfset x.modelo='asp'>
                <cfset ArrayAppend(listTablas,x)>

                <cfset x = StructNew()>
                <cfset x.tabla='CuentaEmpresarial'>
                <cfset x.cols='CEnombre'>    
                <cfset x.llave='CEcodigo'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
                
            </cfif>
            
            <cfif arguments.squema eq 'sifcontrol'>
				<cfset x = StructNew()>
                <cfset x.tabla='CodigoError'>
                <cfset x.cols='CERRmsg,CERRdes,CERRcor'>	 
                <cfset x.llave='CERRcod'>
                <cfset x.llaveType='n'>
                <cfset ArrayAppend(listTablas,x)>
            </cfif>
            
		
			<cfif isdefined("arguments.tabla") and len(trim(arguments.tabla))>
				<cfset NewListaTabla = ArrayNew(1)>
				<cfloop from="1" to="#arraylen(listTablas)#" index="i">
					<cfif listTablas[i].tabla eq arguments.tabla>
						<cfset ArrayAppend(NewListaTabla,listTablas[i])>
					</cfif>
				</cfloop>
				<cfset listTablas = NewListaTabla>
			</cfif>
			<cfreturn listTablas>
	</cffunction>
	
	<cffunction name="getMetaDataTable" returntype="struct">
		<cfargument name="tabla" 	required="yes" type="string">
		<cfargument name="colOri" 	required="yes" type="string">
		<cfargument name="dsn" 		required="yes" type="string">

		<cfset LvarDBtype		= ucase(Application.dsinfo[arguments.dsn].type)>
		<cfset rs = StructNew()>
		
		<cfif LvarDBtype eq 'SYBASE' or LvarDBtype eq 'SQLSERVER'>
			<cfquery datasource="#arguments.dsn#" name="rsinfo">
				SELECT obj.name as tabla,col.name as columna, col.length as tam, tip.name as tipo
				FROM sysobjects obj 
					INNER JOIN syscolumns col
						ON obj.id = col.id 
					inner JOIN systypes tip
						ON col.usertype  = tip.usertype 
				WHERE obj.type = 'U' 
				and obj.name = '#arguments.tabla#'
				and col.name = '#arguments.colOri#'
			</cfquery> 
			<cfset rs.tabla = rsinfo.tabla>
			<cfset rs.col = rsinfo.columna>
			<cfset rs.tam = rsinfo.tam>
			<cfset rs.tipo = rsinfo.tipo>
			<cfset rs.DBtype = LvarDBtype>
		<cfelse>
			<cf_throw message="No se ha definido un getMetadata para #LvarDBtype#">
		</cfif>	
		
		<cfreturn rs>
	</cffunction>
	
	<cffunction name="validaColumna" returntype="boolean">
		<cfargument name="tabla" 	type="string" required="yes">
		<cfargument name="Col" 		type="string" required="yes">
		<cfargument name="dsn" 		required="yes" type="string">
		<cfset existe=false>
	
		<cftry>
			<cfquery datasource="#dsn#">
				select #arguments.Col#
				from #arguments.tabla#
				where 1=2
			</cfquery> 
			<cfset existe=true>
			<cfcatch type="database">
				<cfset existe=false>
			</cfcatch>	
		</cftry> 
		<cfreturn existe>
	</cffunction>
	
	<cffunction name="getData" returntype="query">
		<cfargument name="tabla" 		required="yes" type="string">
		<cfargument name="col" 			required="yes" type="string">
		<cfargument name="llave" 		required="yes" type="string">
		<cfargument name="idiomas" 		required="yes" type="string">
		<cfargument name="datasource" 	required="yes" type="string">
		<cfargument name="Ecodigo" 		required="no" type="string">
 
		<cfset cols=''>
		<cfloop list="#idiomas#" index="i">
			<cfif  validaColumna(arguments.tabla,arguments.col&'_'&trim(i),arguments.datasource)>
				<cfset cols = ListAppend(cols,arguments.col&'_'&trim(i)) >
			</cfif>
		</cfloop>
		<cfif not len(trim(cols))>
			<cfthrow message="No existen Columnas creadas">
		</cfif>
		<cfquery datasource="#arguments.datasource#" name="rsInfo">
			select #arguments.llave#,#arguments.col# as defecto, #cols# from #arguments.tabla#
			where 1=1
			<cfif isdefined("arguments.Ecodigo") and len(trim(arguments.Ecodigo)) and trim(arguments.Ecodigo) neq 0>
				and Ecodigo = #arguments.Ecodigo#
			</cfif>
		</cfquery>
		<cfreturn rsInfo>
	</cffunction>


	<cffunction name="getIdiomas" returntype="query">
		<cfargument name="datasource" type="string" required="yes">
	                <cfif arguments.datasource eq 'asp'>
                                <cfset arguments.datasource = 'sifcontrol'>
                        </cfif>
			<cfquery datasource="#arguments.datasource#" name="rsIdiomas">
				select Iid, rtrim(ltrim(Icodigo)) as Icodigo, Descripcion 
				from Idiomas
				where rtrim(ltrim(Icodigo)) not  in ('es_MX','es_CR_NAC','es_PA','es_SV','es_GT')
			</cfquery>
		<cfreturn rsIdiomas>
	</cffunction>
	
	
	<cffunction name="updateDataFromAjax" access="remote" returntype="string" returnFormat = "plain"> 
		<cfargument name="datasource" 	type="string" required="yes">
		<cfargument name="tabla" 		type="string" required="yes">
		<cfargument name="PK" 			type="string" required="yes">
		<cfargument name="PKType" 		type="string" required="yes">
		<cfargument name="data"			type="array" required="yes">
		<cfargument name="id"			type="numeric" required="yes">

		<cfset info = getTablas(trim(arguments.tabla))>
			
		<cfloop from="1" to="#Arraylen(arguments.data)#" index="i">
			<cfquery datasource="#arguments.datasource#">
				UPDATE #arguments.tabla#
				SET #data[i].col#  =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(data[i].value)#">
				WHERE 1=1
				<cfloop list="#arguments.PK#" index="w">
					<cfset pos = listfindnocase(arguments.PK,w)>
					<cfset type = ListGetAt(arguments.PKType,pos)>
					<cfset valor = ListGetAt(arguments.data[i].listaPK,pos)>
					
					<cfif type eq 'v'>
						and ltrim(rtrim(#w#)) = '#trim(valor)#'
					<cfelseif type eq 't'>
						and #w# = '#trim(valor)#'
					<cfelseif type eq 'n'>
						and #w# = #trim(valor)#
					</cfif>
				</cfloop>			 
			</cfquery>
		</cfloop>
		<cfreturn arguments.id>
	</cffunction>
	
	<cffunction name="getEmpresas" returntype="query">
		<cfargument name="datasource" type="string" required="yes">
		<cfquery datasource="#arguments.datasource#" name="rsEmpresas">
			select Ecodigo,Edescripcion
			from Empresas
			order by Edescripcion
		</cfquery>
		<cfreturn rsEmpresas>
	</cffunction>
	
	<cffunction name="updateParamTraduccion" returntype="numeric" access="remote">
		<cfargument name="datasource" type="string" required="yes">
		<cfargument name="Ecodigo" type="numeric" required="yes">
		<cfargument name="valor"   type="boolean" required="yes">
		
		<cfinvoke component="rh.Componentes.RHParametros" method="set">
			<cfinvokeargument name="datasource" value="#arguments.datasource#">
			<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#">
			<cfinvokeargument name="Pcodigo" value="2700">
			<cfif arguments.valor>
				<cfinvokeargument name="Pvalor" value="1">
			<cfelse>
				<cfinvokeargument name="Pvalor" value="0">	
			</cfif>
			<cfinvokeargument name="Pdescripcion" value="Utiliza Traduccion de Datos">
		</cfinvoke>	
					
		<cfreturn arguments.Ecodigo>
	</cffunction>
	
	
	<cffunction name="getParamTraduccion" returntype="boolean">
		<cfargument name="Ecodigo" type="numeric" required="yes">
		
		<cfquery datasource="asp" name="rsInfo">
			select Ccache
			from Empresa e
				inner join Caches c
					on e.Cid =c.Cid
			where Ereferencia = #arguments.Ecodigo#
		</cfquery>
		
		<cftry>
		<cfinvoke component="rh.Componentes.RHParametros" method="get" returnvariable="lvarParam">
			<cfinvokeargument name="datasource" value="#rsInfo.Ccache#">
			<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#">
			<cfinvokeargument name="Pvalor" value="2700">
			<cfinvokeargument name="default" value="0">
		</cfinvoke>	
			<cfcatch type="database">
				<cfset lvarParam= 0>
			</cfcatch>
		</cftry>
		
		<cfreturn lvarParam>
		
	</cffunction>

        <cffunction name="getTranslatedataCols" returntype="string">
                <cfargument name="tabla"        type="string" required="yes">
                <cfargument name="datasource"   type="string" required="yes">
                <cfset data = getTablas(trim(arguments.tabla),arguments.datasource)> 
                <cfset cols=''>
                <cfif arraylen(data)>
                        <cfset idiomas = getIdiomas(arguments.datasource)>
                        <cfloop list="#data[1].cols#" index="j">
                                <cfloop query="#idiomas#">        
                                        <cfif  validaColumna(arguments.tabla,j&'_'&trim(idiomas.Icodigo),arguments.datasource)>
                                                <cfset cols = ListAppend(cols,j&'_'&trim(idiomas.Icodigo)) >
                                        </cfif>
                                </cfloop>
                        </cfloop>
                </cfif>
                <cfreturn cols>    
        </cffunction>
        
	
</cfcomponent>
