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

using Cairo;
using Gtk;

namespace EV3IREyes {
	public class EyesWidget : Misc {
		const double ASPECT_RATIO = 1.6;

		int _heading;
		public int heading {
			get { return _heading; }
			set {
				_heading = value;
				queue_draw ();
			}
		}

		int _proximity;
		public int proximity {
			get { return _proximity; }
			set {
				_proximity = value;
				queue_draw ();
			}
		}

		public override bool draw (Context cr) {
			Allocation allocation;
			get_allocation (out allocation);
			var width = allocation.width;
			var height = allocation.height;
			var vcenter = width / 2.0;
			var hcenter = height / 2.0;
			var eye_width = height / 1.5;
			var eye_height = height / 1.1;
			var eye_offset = height / 2.7;
			var eyes_closed = proximity == -128;
			cr.set_source_rgb (1, 1, 1);
			cr.paint ();
			cr.set_source_rgb (0, 0, 0);
			elipse (cr, vcenter - eye_offset, hcenter, eye_width, eye_height, eyes_closed);
			elipse (cr, vcenter + eye_offset, hcenter, eye_width, eye_height, eyes_closed);
			if (!eyes_closed) {
				var pupil_size = eye_width / 3.0;
				var pupil_heading_offset = heading / 25.0 * eye_width / 4.0;
				var pupil_proximity_offset = proximity > 25 ? 0
					: (25 - proximity) / 25.0 * eye_width / 4.0;
				fill_circle (cr, vcenter - eye_offset - pupil_heading_offset 
					+ pupil_proximity_offset, hcenter + pupil_size / 2,pupil_size);
				fill_circle (cr, vcenter + eye_offset - pupil_heading_offset 
					- pupil_proximity_offset, hcenter + pupil_size / 2, pupil_size);
			}
			return false;
		}

		void elipse (Context cr, double x, double y, double width, double height, bool with_chord = false) {
			const double offset = 0.7;
			cr.save ();
			cr.translate (x, y);
			cr.scale (width / 2.0, height / 2.0);
			cr.arc (0.0, 0.0, 1.0, offset, offset + 2 * Math.PI);
			if (with_chord)
				cr.arc (0.0, 0.0, 1.0, Math.PI - offset, Math.PI - offset);
			cr.restore ();
			cr.stroke ();
		}

		void fill_circle (Context cr, double x, double y, double diameter) {
			cr.save ();
			cr.translate (x, y);
			cr.scale (diameter / 2.0, diameter / 2.0);
			cr.arc (0.0, 0.0, 1.0, 0.0, 2 * Math.PI);
			cr.restore ();
			cr.fill ();
		}

		public override void get_preferred_width (out int minimum_width, out int natural_width) {
			minimum_width = 600;
			natural_width = minimum_width;
		}

		public override void get_preferred_height (out int minimum_height, out int natural_height) {
			minimum_height = 375;
			natural_height = minimum_height;
		}

		public override void get_preferred_height_for_width (int width, out int minimum_height, out int natural_height) {
			minimum_height = (int)(width / ASPECT_RATIO);
			natural_height = minimum_height;
		}

		public override void get_preferred_width_for_height (int height, out int minimum_width, out int natural_width) {
			minimum_width = (int)(height * ASPECT_RATIO);
			natural_width = minimum_width;
		}
	}
}