<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeBehind="Employee.aspx.cs" Inherits="WebApplication1.Employee" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/all.css" integrity="sha384-UHRtZLI+pbxtHCWp1t77Bi1L4ZtiqrqD80Kn4Z8NTSRyMA2Fd33n5dQ8lWUE00s/" crossorigin="anonymous" />
    <script src="https://code.jquery.com/jquery-3.5.1.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <!-- SweetAlert2 -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/7.2.0/sweetalert2.all.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/7.2.0/sweetalert2.min.css" />

    <!--Datepicker-->
    <script src="https://unpkg.com/gijgo@1.9.13/js/gijgo.min.js" type="text/javascript"></script>
    <link href="https://unpkg.com/gijgo@1.9.13/css/gijgo.min.css" rel="stylesheet" type="text/css" />

    <!--Datatable-->
    <script src="https://cdn.datatables.net/1.10.25/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.25/js/dataTables.bootstrap4.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.2/css/bootstrap.css" rel="stylesheet" type="text/css" />
    <link href="https://cdn.datatables.net/1.10.25/css/dataTables.bootstrap4.min.css" rel="stylesheet" type="text/css" />

    <style>
        @media screen and (max-width: 992px) {
            .scrollbar {
                overflow-x: scroll;
            }

            .actionBtns {
                display: none;
            }

            .employeeTable {
                width:1370px;
            }
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            var CountryDDL = $('#DDLCountry');
            var StateDDL = $('#DDLState');
            var CityDDL = $('#DDLCity');

            $.ajax({
                url: 'CascadingDataService.asmx/GetCountry',
                type: 'POST',
                dataType: 'json',
                success: function (data) {
                    CountryDDL.append($('<option/>', { value: -1, text: 'Select Country' }));
                    StateDDL.append($('<option/>', { value: -1, text: 'Select State' }));
                    CityDDL.append($('<option/>', { value: -1, text: 'Select City' }));
                    StateDDL.prop('disabled', true);
                    CityDDL.prop('disabled', true);
                    $(data).each(function (index, item) {
                        CountryDDL.append($('<option/>', { value: item.Row_Id, text: item.CountryName }));
                    });

                    if (document.getElementById("<%=HFExisCountry.ClientID%>").value != "") {
                        $('#DDLCountry').val(document.getElementById("<%=HFExisCountry.ClientID%>").value);
                    }
                }
            });

            if ($('#DDLCountry').val() != "-1") {
                $.ajax({
                    url: 'CascadingDataService.asmx/GetState',
                    type: 'POST',
                    data: { CountryId: document.getElementById("<%=HFExisCountry.ClientID%>").value },
                    dataType: 'json',
                    success: function (data) {
                        StateDDL.empty();
                        StateDDL.append($('<option/>', { value: -1, text: 'Select State' }));
                        StateDDL.prop('disabled', false);
                        $(data).each(function (index, item) {
                            StateDDL.append($('<option/>', { value: item.Row_Id, text: item.StateName }));
                        });

                        if (document.getElementById("<%=HFExisState.ClientID%>").value != "") {
                            $('#DDLState').val(document.getElementById("<%=HFExisState.ClientID%>").value);
                        }
                    }
                });
            }

            if ($('#DDLState').val() != "-1") {
                $.ajax({
                    url: 'CascadingDataService.asmx/GetCity',
                    type: 'POST',
                    data: { StateId: document.getElementById("<%=HFExisState.ClientID%>").value },
                    dataType: 'json',
                    success: function (data) {
                        CityDDL.empty();
                        CityDDL.append($('<option/>', { value: -1, text: 'Select City' }));
                        CityDDL.prop('disabled', false);
                        $(data).each(function (index, item) {
                            CityDDL.append($('<option/>', { value: item.Row_Id, text: item.CityName }));
                        });

                        if (document.getElementById("<%=HFExisCity.ClientID%>").value != "") {
                            $('#DDLCity').val(document.getElementById("<%=HFExisCity.ClientID%>").value);
                        }
                    }
                });
            }

            CountryDDL.change(function () {
                var HFcountry = $(this).val();
                document.getElementById('<%=HFCountry.ClientID%>').value = HFcountry;

                if ($(this).val() == "-1") {
                    StateDDL.empty();
                    CityDDL.empty();
                    StateDDL.append($('<option/>', { value: -1, text: 'Select State' }));
                    CityDDL.append($('<option/>', { value: -1, text: 'Select City' }));
                    StateDDL.val('-1');
                    CityDDL.val('-1');
                    StateDDL.prop('disabled', true);
                    CityDDL.prop('disabled', true);
                }
                else {
                    $.ajax({
                        url: 'CascadingDataService.asmx/GetState',
                        type: 'POST',
                        data: { CountryId: $(this).val() },
                        dataType: 'json',
                        success: function (data) {
                            StateDDL.empty();
                            StateDDL.append($('<option/>', { value: -1, text: 'Select State' }));
                            StateDDL.prop('disabled', false);
                            CityDDL.empty();
                            CityDDL.append($('<option/>', { value: -1, text: 'Select City' }));
                            CityDDL.prop('disabled', true);
                            $(data).each(function (index, item) {
                                StateDDL.append($('<option/>', { value: item.Row_Id, text: item.StateName }));
                            });
                        }
                    });
                }
            });

            StateDDL.change(function () {
                var HFstate = $(this).val();
                document.getElementById('<%=HFState.ClientID%>').value = HFstate;

                if ($(this).val() == "-1") {
                    CityDDL.empty();
                    CityDDL.append($('<option/>', { value: -1, text: 'Select City' }));
                    CityDDL.val('-1');
                    CityDDL.prop('disabled', false);
                }
                else {
                    $.ajax({
                        url: 'CascadingDataService.asmx/GetCity',
                        type: 'POST',
                        data: { StateId: $(this).val() },
                        dataType: 'json',
                        success: function (data) {
                            CityDDL.empty();
                            CityDDL.append($('<option/>', { value: -1, text: 'Select City' }));
                            CityDDL.prop('disabled', false);
                            $(data).each(function (index, item) {
                                CityDDL.append($('<option/>', { value: item.Row_Id, text: item.CityName }));
                            });
                        }
                    });
                }
            });

            CityDDL.change(function () {
                var HFcity = $(this).val();
                document.getElementById('<%=HFCity.ClientID%>').value = HFcity;
            });
        });
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid">
            <asp:HiddenField ID="HFCountry" runat="server"></asp:HiddenField>
            <asp:HiddenField ID="HFState" runat="server"></asp:HiddenField>
            <asp:HiddenField ID="HFCity" runat="server"></asp:HiddenField>
            <asp:HiddenField ID="HFExisCountry" runat="server"></asp:HiddenField>
            <asp:HiddenField ID="HFExisState" runat="server"></asp:HiddenField>
            <asp:HiddenField ID="HFExisCity" runat="server"></asp:HiddenField>
            <asp:HiddenField ID="HFUpdatedCountry" runat="server"></asp:HiddenField>
            <asp:HiddenField ID="HFUpdatedState" runat="server"></asp:HiddenField>
            <asp:HiddenField ID="HFUpdatedCity" runat="server"></asp:HiddenField>

            <div class="row">
                <div class="col-lg-4 col-12"></div>
                <div class="col-lg-4 text-center col-12">
                    <h3>Employee List</h3>
                </div>
                <div class="col-lg-4 text-right col-12">
                    <asp:Button ID="BtnAdd" runat="server" class="btn btn-dark mt-4" Text="Add New Employee" OnClick="BtnAdd_Click" />
                </div>
            </div>
            <!-- The Modal -->
            <div class="modal" id="myModal">
                <div class="modal-dialog modal-lg modal-dialog-scrollable">
                    <div class="modal-content">
                        <!-- Modal Header -->
                        <div class="modal-header">
                            <h4 class="modal-title">Add/Edit Employee</h4>
                            <asp:HiddenField ID="HFRowId" runat="server" />
                            <asp:HiddenField ID="HFExisImage" runat="server" />
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                        </div>

                        <!-- Modal body -->
                        <div class="modal-body">
                            <div class="my-3">
                                <div class="form-group row">
                                    <div class="col-lg-3 text-lg-right">
                                        First Name
                                    </div>
                                    <div class="col-lg-6">
                                        <asp:TextBox ID="TxtFirstName" runat="server" class="form-control" MaxLength="50" placeholder="First Name"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-lg-3 text-lg-right">
                                        Last Name
                                    </div>
                                    <div class="col-lg-6">
                                        <asp:TextBox ID="TxtLastName" runat="server" class="form-control" MaxLength="50" placeholder="Last Name"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-lg-3 text-lg-right">
                                        Email Address
                                    </div>
                                    <div class="col-lg-6">
                                        <asp:TextBox ID="TxtEmail" runat="server" class="form-control" MaxLength="100" placeholder="Email"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-lg-3 text-lg-right">
                                        Mobile Number
                                    </div>
                                    <div class="col-lg-6">
                                        <asp:TextBox ID="TxtMobile" runat="server" class="form-control" MaxLength="10" onkeypress="return checkPosInt(event)" placeholder="Mobile Number"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-lg-3 text-lg-right">
                                        PAN Number
                                    </div>
                                    <div class="col-lg-6">
                                        <asp:TextBox ID="TxtPAN" runat="server" class="form-control" MaxLength="12" placeholder="Pan Number"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-lg-3 text-lg-right">
                                        Passport Number
                                    </div>
                                    <div class="col-lg-6">
                                        <asp:TextBox ID="TxtPassport" runat="server" class="form-control" MaxLength="8" placeholder="Passport Number"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-lg-3 text-lg-right">
                                        Date Of Birth
                                    </div>
                                    <div class="col-lg-6">
                                        <asp:TextBox ID="TxtDOB2" runat="server" class="form-control" placeholder="Date Of Birth" autocomplete="off"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-lg-3 text-lg-right">
                                        Date Of Joinee
                                    </div>
                                    <div class="col-lg-6">
                                        <asp:TextBox ID="TxtDOJ2" runat="server" class="form-control" placeholder="Date Of Joinee" autocomplete="off"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-lg-3 text-lg-right">
                                        Country
                                    </div>
                                    <div class="col-lg-6">
                                        <asp:DropDownList ID="DDLCountry" runat="server" class="form-control" EnableViewState="true"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-lg-3 text-lg-right">
                                        State
                                    </div>
                                    <div class="col-lg-6">
                                        <asp:DropDownList ID="DDLState" runat="server" class="form-control"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-lg-3 text-lg-right">
                                        City
                                    </div>
                                    <div class="col-lg-6">
                                        <asp:DropDownList ID="DDLCity" runat="server" class="form-control"></asp:DropDownList>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-lg-3 text-lg-right">
                                        Profile Picture
                                    </div>
                                    <div class="col-6">
                                        <asp:FileUpload ID="FUProfileImg" runat="server" class="form-control" />
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-lg-3 text-lg-right">
                                        Gender
                                    </div>
                                    <div class="col-lg-6">
                                        <asp:RadioButtonList ID="RdbtnGender" runat="server" RepeatDirection="Horizontal">
                                            <asp:ListItem Text="Male" Value="0" Selected="True"></asp:ListItem>
                                            <asp:ListItem Text="Female" Value="1"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-lg-3 text-lg-right">
                                        Active
                                    </div>
                                    <div class="col-lg-6">
                                        <asp:CheckBox ID="ChckIsActive" runat="server" Text="Active" class="form-check" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Modal footer -->
                        <div class="modal-footer mx-auto">
                            <asp:Button ID="BtnSave" runat="server" Text="Save" class="btn btn-success" OnClick="BtnSave_Click" OnClientClick="return ValidateForm();" />
                            <asp:Button ID="BtnUpdate" runat="server" Text="Update" class="btn btn-success" OnClick="BtnUpdate_Click" OnClientClick="return ValidateUpdateForm();" />
                        </div>

                    </div>
                </div>
            </div>

            <div class="mt-3 scrollbar">
                <asp:Repeater ID="RptrEmployee" runat="server" OnItemCommand="RptrEmployee_ItemCommand" OnItemDataBound="RptrEmployee_ItemDataBound">
                    <HeaderTemplate>
                        <table id="EmployeeTable" class="table table-bordered text-center employeeTable">
                            <thead>
                                <tr>
                                    <td>Email</td>
                                    <td>Country</td>
                                    <td>State</td>
                                    <td>City</td>
                                    <td>Pan No</td>
                                    <td>Passport No</td>
                                    <td>Gender</td>
                                    <td>Is Active</td>
                                    <td>Profile Image</td>
                                    <td>Action</td>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td><%# Eval("EmailAddress") %></td>
                            <td><%# Eval("CountryName") %></td>
                            <td><%# Eval("StateName") %></td>
                            <td><%# Eval("CityName") %></td>
                            <td><%# Eval("PanNumber") %></td>
                            <td><%# Eval("PassportNumber") %></td>
                            <td><%# getGender(Eval("Gender").ToString()) %></td>
                            <td><%# getIsActive(Eval("IsActive").ToString()) %></td>
                            <td>
                                <asp:Image ID="ImgProfile" runat="server" Height="50px" Width="50px" ImageUrl='<%# "/Uploads/Employee/" + Eval("ProfileImage") %>' />
                                <asp:Label ID="LblNoImage" runat="server" Visible="false" Text="No Image"></asp:Label>
                            </td>
                            <td>
                                <div class="row">
                                    <div class="col-6 px-0"><asp:LinkButton ID="LnkBtnEdit" runat="server" CommandName="Edit" CommandArgument='<%#Eval("Row_Id") %>' class="btn btn-success"><i class="fa fa-edit"></i><span class="actionBtns"> Edit</span></asp:LinkButton></div>
                                    <div class="col-6 px-0"><asp:LinkButton ID="LnkBtnDelete" runat="server" CommandName="Delete" OnClientClick="sweetAlertConfirm(this);" CommandArgument='<%#Eval("Row_Id") %>' class="btn btn-danger"><i class="fa fa-trash"></i><span class="actionBtns"> Delete</span></asp:LinkButton></div>
                                </div>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                        </tbody>                   
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
        </div>
    </form>
    <script>

        $(document).ready(function () {
            $('#EmployeeTable').DataTable();
        });

        function validateDOB(dateString) {

            var parts = dateString.split("/");
            var dtDOB = new Date(parts[1] + "/" + parts[0] + "/" + parts[2]);
            var dtCurrent = new Date();

            if (dtCurrent.getFullYear() - dtDOB.getFullYear() < 18) {
                return false;
            }
            if (dtCurrent.getFullYear() - dtDOB.getFullYear() == 18) {
                if (dtCurrent.getMonth() < dtDOB.getMonth()) {
                    return false;
                }
                if (dtCurrent.getMonth() == dtDOB.getMonth()) {
                    if (dtCurrent.getDate() < dtDOB.getDate()) {
                        return false;
                    }
                }
            }
            if (dtCurrent.getFullYear() - dtDOB.getFullYear() <= 65) {
                return true;
            }
            else {
                return false;
            }

            return true;
        }

        function validateDOJ(dateString) {

            var parts = dateString.split("/");
            var dtDOB = new Date(parts[1] + "/" + parts[0] + "/" + parts[2]);
            var dtCurrent = new Date();

            if (dtCurrent.getFullYear() - dtDOB.getFullYear() <= 65) {
                return true;
            }
            else {
                return false;
            }

            return true;
        }

        function checkPosInt(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }

        function validateMobile(Mobile) {
            if (Mobile.value.length < 10) {
                return false;
            }
            else {
                return true;
            }
        }

        function validatePan(PanNumber) {
            var regex = /([A-Z]){5}([0-9]){4}([A-Z]){1}$/;
            return regex.test($(PanNumber).val().toUpperCase());
        }

        function validatePassport(PassportNumber) {
            var patt = new RegExp("^([A-Z a-z]){1}([0-9]){7}$")
            return patt.test(String(PassportNumber).toUpperCase());
        }

        function validateEmail(email) {
            const re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            return re.test(String(email).toLowerCase());
        }

        function ValidateForm() {
            if (document.getElementById('<%=TxtFirstName.ClientID%>').value == '') {
                alert("Please enter your first name");
                document.getElementById('<%=TxtFirstName.ClientID%>').focus();
                return false;
            }
            else if (document.getElementById('<%=TxtLastName.ClientID%>').value == '') {
                alert("Please enter your last name");
                document.getElementById('<%=TxtLastName.ClientID%>').focus();
                return false;
            }
            else if (document.getElementById('<%=TxtEmail.ClientID%>').value == '') {
                alert("Please enter your Email Address");
                document.getElementById('<%=TxtEmail.ClientID%>').focus();
                return false;
            }
            else if (!validateEmail(document.getElementById('<%=TxtEmail.ClientID%>').value)) {
                alert("Please enter valid Email Address");
                document.getElementById('<%=TxtEmail.ClientID%>').focus();
                return false;
            }
            else if (document.getElementById('<%=TxtMobile.ClientID%>').value == '') {
                alert("Please enter your Mobile Number");
                document.getElementById('<%=TxtMobile.ClientID%>').focus();
                return false;
            }
            else if (!validateMobile(document.getElementById('<%=TxtMobile.ClientID%>'))) {
                alert("Please enter valid Mobile Number");
                document.getElementById('<%=TxtMobile.ClientID%>').focus();
                return false;
            }
            else if (document.getElementById('<%=TxtPAN.ClientID%>').value == '') {
                alert("Please enter your PAN Number");
                document.getElementById('<%=TxtPAN.ClientID%>').focus();
                return false;
            }
            else if (!validatePan(document.getElementById('<%=TxtPAN.ClientID%>'))) {
                alert("Please enter valid PAN Number");
                document.getElementById('<%=TxtPAN.ClientID%>').focus();
                return false;
            }
            else if (document.getElementById('<%=TxtPassport.ClientID%>').value == '') {
                alert("Please enter your Passport Number");
                document.getElementById('<%=TxtPassport.ClientID%>').focus();
                return false;
            }
            else if (!validatePassport(document.getElementById('<%=TxtPassport.ClientID%>').value)) {
                alert("Please enter valid Passport Number");
                document.getElementById('<%=TxtPassport.ClientID%>').focus();
                return false;
            }
            else if (document.getElementById('<%=TxtDOB2.ClientID%>').value == '') {
                alert("Please enter your Date Of Birth");
                document.getElementById('<%=TxtDOB2.ClientID%>').focus();
                return false;
            }
            else if (!validateDOB(document.getElementById('<%=TxtDOB2.ClientID%>').value)) {
                alert("Your age should be between 18 and 65!");
                document.getElementById('<%=TxtDOB2.ClientID%>').focus();
                return false;
            }
            else if (document.getElementById('<%=DDLCountry.ClientID%>').value == '-1') {
                alert("Please select Country");
                document.getElementById('<%=DDLCountry.ClientID%>').focus();
                return false;
            }
            else if (document.getElementById('<%=DDLState.ClientID%>').value == '-1') {
                alert("Please select State");
                document.getElementById('<%=DDLState.ClientID%>').focus();
                return false;
            }
            else if (document.getElementById('<%=DDLCity.ClientID%>').value == '-1') {
                alert("Please select City");
                document.getElementById('<%=DDLCity.ClientID%>').focus();
                return false;
            }

            if (document.getElementById('<%=TxtDOJ2.ClientID%>').value != "") {

                if (!validateDOJ(document.getElementById('<%=TxtDOJ2.ClientID%>').value)) {
                    alert("Your date of joining is invalid!");
                    document.getElementById('<%=TxtDOJ2.ClientID%>').focus();
                    return false;
                }
            }

            return true;
        }

        function ValidateUpdateForm() {
            if (!ValidateForm()) {
                return false;
            }

            var updatedCountry = $('select#DDLCountry option:selected').val()
            document.getElementById("<%=HFUpdatedCountry.ClientID%>").value = updatedCountry;

            var updatedState = $('select#DDLState option:selected').val()
            document.getElementById("<%=HFUpdatedState.ClientID%>").value = updatedState;

            var updatedCity = $('select#DDLCity option:selected').val()
            document.getElementById("<%=HFUpdatedCity.ClientID%>").value = updatedCity;
        }

        var today = new Date();
        var tomorrow = new Date();
        tomorrow.setDate(today.getDate() - 1);

        $('#TxtDOB2').datepicker({
            uiLibrary: 'bootstrap4',
            maxDate: tomorrow,
            format: "dd/mm/yyyy"
        });

        $('#TxtDOJ2').datepicker({
            uiLibrary: 'bootstrap4',
            maxDate: tomorrow,
            format: "dd/mm/yyyy"
        });

        function sweetAlertConfirm(btnDelete) {
            if (btnDelete.dataset.confirmed) {
                btnDelete.dataset.confirmed = false;
                return true;
            } else {
                event.preventDefault();
                swal({
                    title: 'Are you sure?',
                    text: "You want to delete this record?",
                    type: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, delete it!'
                }).then((result) => {
                    if (result.value) {
                        btnDelete.dataset.confirmed = true;
                        btnDelete.click();
                    } else if (result.dismiss === 'cancel') {
                        swal(
                            'Cancelled',
                            'Your stay here :)',
                            'error'
                        )
                    }
                })
            }
        }
    </script>
</body>
</html>
