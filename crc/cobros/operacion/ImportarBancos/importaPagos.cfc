component{
    public function importaReferenciados(any file){
        //Los pagos referenciados vienen de un archivo .exp 
        /* Convenio: Considerar la posición 1 al 7 y agregar un cero a la izquierda
        Numero Cuenta: Considerar la posición del 12 al 19
        Monto: Considerar la posición 113 al 124
        Fecha :Considerar la posición 141 al 150 */
        //EJ. de linea del archivo 154648100121906007202411082PAGO 31 OCTUBRE 2024          0000000000881.000000000000000.000000000000000.000000000000881.000068602352024-10-312024-10-31CIUDAD DE 0998CCT
        myfile = FileOpen(arguments.file, "read"); 
        _convenio = createObject("component", "crc.Componentes.CRCParametros").GetParametroInfo('30300102').Valor;
        pagos =  [];
        montoTotal = 0;
        while(NOT FileisEOF(myfile)) { 
            pago = StructNew();
            linea = FileReadLine(myfile);
            if(mid(linea,1,5) eq 'TOTAL'){
                break;
            }
            convenio = mid(linea,1,7);
            pago.convenio = "0#convenio#";
            if (_convenio == pago.convenio) {
                pago.cuenta = mid(linea,12,7);
                _monto = LSParseNumber(mid(linea,113,11));
                pago.monto = _monto;
                pago.fecha= parseDateTime(mid(linea,131,10));
                arrayAppend(pagos, pago);
                montoTotal  += _monto;
            } else {
                throw(type = "Convenio_Invalido", message = "Existen Pagos que no corresponden al Convenio de la Empresa (#_convenio#)-(#pago.convenio#)");
            }
        }
        FileClose(myfile); 
        result.pagos = pagos;
        result.montoTotal = montoTotal;
        return result;
    }
    public function importaNoReferenciados(any file, any form){
        /* 
        Ejemplo de una linea:
        12/11/2024,SPEI RECIBIDOCOMPARTAMOS,0161441973  130,0121124Joselin zamarripa,737.02,178418.95
        Se consideraron la posisión 1 = fecha, 2 = concepto (Que solo sea SPEI o PAGO CUENTA DE TERCERO), 3 = Referencia, 5= Monto 
        */
        documento = fileRead(arguments.file);
        archivo = xmlParse(documento);
        linea = "";
        linea = listToArray(linea);
        
        for(i=3; i lte arrayLen(archivo.Workbook.Worksheet.table.row); i++){
            concepto = archivo.Workbook.Worksheet.table.row[i].XmlChildren[2].XmlChildren[1].XmlText;
            if(FindNoCase("SPEI", concepto) gt 0 or FindNoCase("PAGO CUENTA DE TERCERO", concepto) gt 0 ) {
                fecha = archivo.Workbook.Worksheet.table.row[i].XmlChildren[1].XmlChildren[1].XmlText;
              
                fecha = dateFormat(createDate(mid(fecha,1,4), mid(fecha,6,2), mid(fecha,9,2)), "yyyy-mm-dd");
                monto = archivo.Workbook.Worksheet.table.row[i].XmlChildren[6].XmlChildren[1].XmlText;
                referencia = archivo.Workbook.Worksheet.table.row[i].XmlChildren[3].XmlChildren[1].XmlText;
                linea.append(fecha);
                linea.append(referencia);
                linea.append(monto);
                insertaNoReferenciados(linea, form);
                linea.clear();
            } 
           
        }

        return true;
    }
    private function insertaNoReferenciados(any pagos, any form, string Ecodigo = "#session.Ecodigo#", string Database ="#session.DSN#"){
         queryExecute(
            "insert into PagosNoReferenciados(Ecodigo,FCid,CCTcodigo,CFid,Mcodigo,TCambio,FATid,id_zona,PNRMonto,PNRFecha,PNRReferencias,BMFecha,BMusuario) 
            values(:Ecodigo,:FCid,:CCTcodigo,:CFid,:Mcodigo,:TCambio,:FATid,:id_zona,:PNRMonto,:PNRFecha,:PNRReferencias,GETDATE(),:BMusuario)",
            {   
                Ecodigo: Ecodigo,
                FCid: "#arguments.form.Id_Caja#",
                CCTcodigo: "#arguments.form.CCTcodigo#",
                CFid: "#arguments.form.CFid#",
                Mcodigo: "#arguments.form.Mcodigo#",
                TCambio: "#arguments.form.TCambio#",
                FATid: "#arguments.form.Id_Tarjeta#",
                id_zona: "#arguments.form.Id_Zona#",
                PNRMonto: "#arguments.pagos[3]#",
                PNRFecha: "#arguments.pagos[1]#",
                PNRReferencias: "#trim(replace(arguments.pagos[2],' ', '', 'all'))#",
                BMusuario: "#Session.Usucodigo#"
            },  
            {   datasource: "#Database#" }
        );
    }
}