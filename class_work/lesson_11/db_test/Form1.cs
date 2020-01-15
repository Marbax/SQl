using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace db_test
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'libraryDB_11DataSet8.PivotExmpl' table. You can move, or remove it, as needed.
            this.pivotExmplTableAdapter.Fill(this.libraryDB_11DataSet8.PivotExmpl);
            // TODO: This line of code loads data into the 'libraryDB_11DataSet7.BooksCountWithGroupingSets' table. You can move, or remove it, as needed.
            this.booksCountWithGroupingSetsTableAdapter.Fill(this.libraryDB_11DataSet7.BooksCountWithGroupingSets);
            // TODO: This line of code loads data into the 'libraryDB_11DataSet6.BooksCountWithCube' table. You can move, or remove it, as needed.
            this.booksCountWithCubeTableAdapter1.Fill(this.libraryDB_11DataSet6.BooksCountWithCube);
            // TODO: This line of code loads data into the 'libraryDB_11DataSet5.BooksCountWithCube' table. You can move, or remove it, as needed.
            this.booksCountWithCubeTableAdapter.Fill(this.libraryDB_11DataSet5.BooksCountWithCube);
            // TODO: This line of code loads data into the 'libraryDB_11DataSet4.BooksCountWithRollUp' table. You can move, or remove it, as needed.
            this.booksCountWithRollUpTableAdapter.Fill(this.libraryDB_11DataSet4.BooksCountWithRollUp);
            // TODO: This line of code loads data into the 'libraryDB_11DataSet3.PriceAmmountWithRollUp' table. You can move, or remove it, as needed.
            this.priceAmmountWithRollUpTableAdapter.Fill(this.libraryDB_11DataSet3.PriceAmmountWithRollUp);
            // TODO: This line of code loads data into the 'libraryDB_11DataSet2.AllLib' table. You can move, or remove it, as needed.
            this.allLibTableAdapter.Fill(this.libraryDB_11DataSet2.AllLib);
            // TODO: This line of code loads data into the 'libraryDB_11DataSet.Exmp' table. You can move, or remove it, as needed.
            this.exmpTableAdapter.Fill(this.libraryDB_11DataSet.Exmp);

        }
    }
}
