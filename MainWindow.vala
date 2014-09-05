// Copyright (c) 2014 David Lechner

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

using Gtk;

namespace EV3IREyes {
	public class MainWindow : Window {
		const string msensor_class_path = "/sys/class/msensor";
		const string IR_SENSOR_TYPE_ID = "33";
		const string IR_SEEK_MODE = "IR-SEEK";

		string heading_path;
		string proximity_path;

		EyesWidget eyes;
		Label heading_label;
		Label proximity_label;

		public MainWindow () {
			title = "EV3 IR Eyes";
			window_position = Gtk.WindowPosition.CENTER;
			set_size_request (600, 400);
			var box = new Box (Orientation.VERTICAL, 0);
			add (box);
			eyes = new EyesWidget ();
			box.pack_start (eyes);
			heading_label = new Label ("???");
			box.pack_start (heading_label, false);
			proximity_label = new Label ("???");
			box.pack_start (proximity_label, false);
			try {
				var msensor_dir = Dir.open (msensor_class_path, 0);
				string? sensor_dir_name = null;
				while ((sensor_dir_name = msensor_dir.read_name ()) != null) {
					var sensor_path = Path.build_filename (msensor_class_path, sensor_dir_name);
					var type_id_path = Path.build_filename (sensor_path, "type_id");
					string type_id;
					FileUtils.get_contents (type_id_path, out type_id);
					type_id = type_id.strip ();
					if (type_id != IR_SENSOR_TYPE_ID)
						continue;
					var mode_path = Path.build_filename (sensor_path, "mode");
					if (!FileUtils.test (mode_path, FileTest.EXISTS))
						throw new FileError.EXIST ("The path '%s' does not exist.".printf (mode_path));
					var mode_file = File.new_for_path (mode_path);
					var mode_file_stream = mode_file.open_readwrite ();
					size_t bytes_written;
					mode_file_stream.output_stream.write_all (IR_SEEK_MODE.data, out bytes_written);
					heading_path = Path.build_filename (sensor_path, "value0");
					proximity_path = Path.build_filename (sensor_path, "value1");
					Timeout.add (100, on_update_timeout);
					break;
				}
				if (heading_path == null)
					throw new FileError.EXIST ("Could not find an IR sensor.");
			} catch (Error err) {
				run_error_dialog (err.message);
			}
		}

		bool on_update_timeout () {
			try {
				string? heading_str;
				FileUtils.get_contents (heading_path, out heading_str);
				var heading = int.parse (heading_str);
				string? proximity_str;
				FileUtils.get_contents (proximity_path, out proximity_str);
				var proximity = int.parse (proximity_str);
				eyes.heading = heading;
				eyes.proximity = proximity;
				heading_label.label = "Heading: %d".printf (heading);
				proximity_label.label = "Proximity: %d".printf (proximity);
			} catch (Error err) {
				run_error_dialog (err.message);
				return false;
			}
			return true;
		}

		void run_error_dialog (string message) {
			var flags = DialogFlags.MODAL;
				var dialog = new MessageDialog (this, flags, MessageType.ERROR,
					ButtonsType.OK, "%s", message);
				dialog.run ();
				dialog.destroy ();
		}
	}
}